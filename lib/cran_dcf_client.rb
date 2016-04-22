require 'net/http'
require 'dcf'

class CranDcfClient
  HOST = 'cran.r-project.org'.freeze
  PATH_PACKAGE_API = '/src/contrib/PACKAGES'.freeze

  # Fetches information of CRAN packages
  #
  # It is possible to specify size of packages with ENV['MAX_INDEX_SIZE'].
  # 50 by default in dev env.
  #
  # @return [Hash] Information of CRAN packages
  def self.fetch_packages
    puts "Fetching list of packages from https://#{HOST}#{PATH_PACKAGE_API}"

    dcf_string = Net::HTTP.get(HOST, PATH_PACKAGE_API)
    dcf = Dcf.parse(dcf_string)
    puts "Found #{dcf.size} packages."
    Rails.env.development? ? dcf.first(Package::MAX_INDEX_SIZE) : dcf
  end

  # Fetches information of a description
  #
  # @return [Hash] Information of a description
  def self.fetch_description(package_name, version)
    archive_file = "#{package_name}_#{version}.tar.gz"
    path_to_description = "#{package_name}/DESCRIPTION"

    # Download archive file
    `wget https://#{HOST}/src/contrib/#{archive_file} --directory-prefix ./tmp`
    puts "Fetching info about description from https://#{HOST}/src/contrib/#{archive_file}"

    # Read the description
    dcf_string = `tar xzfO ./tmp/#{archive_file} #{path_to_description}`
    Dcf.parse(dcf_string).first
  rescue => e
    puts "Error occurred while fetching description for #{package_name}"
    print e
  end
end
