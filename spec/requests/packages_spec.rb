require 'rails_helper'

describe "Packages", type: :request do
  describe "GET /packages" do
    let!(:packages) { Package.make! }

    before { get packages_path(format: :json) }

    it { expect(response).to be_ok }
  end
end
