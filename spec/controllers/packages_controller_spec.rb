require 'rails_helper'

describe PackagesController, type: :controller do
  describe "GET #index" do
    let!(:packages) do
      [Package.make!, Package.make!]
    end

    before { get :index, format: :json }

    it "assigns all packages as @packages" do
      expect(assigns(:packages)).to match_array(packages)
    end
  end
end
