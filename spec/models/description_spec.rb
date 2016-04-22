require 'rails_helper'
require 'csv'

describe Description, type: :model do
  describe "#authors#create_from_csv" do
    let(:description) { Description.make! }
    let(:csv) { "Elizabeth, George, Edward" }

    it "create 3 authors" do
      expect {
        description.authors.create_from_csv(csv)
      }.to change {
        description.authors.size
      }.by(3)
    end
  end

  describe "#maintainers#create_from_csv" do
    let(:description) do
      Description.make!
    end
    let(:csv) do
      "Elizabeth <elizabeth@co.uk>, George <george@co.uk>, Edward <edward@co.uk>"
    end

    it "create 3 authors" do
      expect {
        description.maintainers.create_from_csv(csv)
      }.to change {
        description.maintainers.size
      }.by(3)
    end
  end

  describe ".fetch_dcf" do
    it "delegates CranDcfClient.fetch_description" do
      expect(CranDcfClient).to receive(:fetch_description)
      Description.fetch_dcf(Package.new)
    end
  end

  describe "#latest?" do
    let!(:package) do
      Package.make!.tap {|package|
        package.descriptions.make!(version: '1.2.0')
        package.descriptions.make!(version: '1.2.1')
      }
    end

    context "when no newer description exists" do
      let(:new_description) do
        package.descriptions.make!(version: '1.3.0')
      end

      it { expect(new_description.latest?).to be_truthy }
    end

    context "when newer description exist" do
      let(:new_description) do
        package.descriptions.make!(version: '1.1.1')
      end

      it { expect(new_description.latest?).to be_falsey }
    end
  end
end
