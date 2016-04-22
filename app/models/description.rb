class Description < ActiveRecord::Base
  belongs_to :package
  has_and_belongs_to_many :authors, association_foreign_key: 'committer_id' do
    # Creates author from CSV of authors
    #
    # @param csv [String]
    def create_from_csv(csv)
      CSV.parse(csv).first.each do |author|
        self.find_or_create_by(name: author)
      end
    end
  end
  has_and_belongs_to_many :maintainers, association_foreign_key: 'committer_id' do
    # Creates maintainer from CSV of authors
    #
    # @param csv [String]
    def create_from_csv(csv)
      CSV.parse(csv).first.each do |maintainer|
        mail_address = Mail::Address.new(maintainer)
        self.find_or_create_by(name: mail_address.name, email: mail_address.try(:address))
      end
    end
  end

  def self.fetch_dcf(package)
    CranDcfClient.fetch_description(package.name, package.current_version)
  end

  def latest?
    newer_description = package.descriptions.reload.detect {|description|
        Gem::Version.new(description.version) > Gem::Version.new(version)
      }
    newer_description.blank?
  end
end
