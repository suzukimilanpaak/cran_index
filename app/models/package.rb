require 'csv'

class Package < ActiveRecord::Base
  MAX_INDEX_SIZE = ENV['MAX_INDEX_SIZE'].to_i || 50

  has_many :descriptions do
    # Revises descriptions for a package
    #
    # @param description_dcf [Hash] Information of a Description taken from DCF
    #
    # @return [Description] Description found or created
    def revise(description_dcf)
      return if description_dcf.nil?

      self.find_or_initialize_by(version: description_dcf['Version']).tap {|description|
        if description.new_record?
          description.update_attributes(
            title: description_dcf['Title'],
            description: description_dcf['Description'],
            published_at: description_dcf['Date/Publication']
          )
          description.
            authors.
            create_from_csv(description_dcf['Author'])
          description.
            maintainers.
            create_from_csv(description_dcf['Maintainer'])
          description.
            package.
            replace_current_description_with(description)
        end
      }
    rescue => e
      puts "Error occurred while revising descriptions"
      print e
    end
  end
  belongs_to :current_description,
    class_name: 'Description',
    foreign_key: 'current_description_id'

  def self.list
    relation = all.preload(descriptions: [:authors, :maintainers])
    if Rails.env.development?
      relation.limit(MAX_INDEX_SIZE)
    else
      relation
    end
  end

  # Revises packages
  #
  # Fetches package info from Cran DCF and update if new packages are found.
  # Then, revises its descriptions.
  #
  # @return [Package] Package found or created
  def self.revise
    packages = Enumerator.new do |yielder|
        packages_dcf.each do |package_dcf|
          package = Package.find_or_create_by(name: package_dcf['Package'])
          if package.different_version?(package_dcf['Version'])
            package.update_attribute(:current_version, package_dcf['Version'])
            yielder << package
          end
        end
      end

    packages.each do |package|
      package.descriptions.revise(Description.fetch_dcf(package))
    end
  end

  def replace_current_description_with(description)
    if description.latest?
      update_attribute(:current_description, description)
    end
  end

  def different_version?(version)
    new_record? || current_version != version
  end

  private

  def self.packages_dcf
    CranDcfClient.fetch_packages
  end
end
