class PackagesController < ApplicationController
  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.list
  end
end
