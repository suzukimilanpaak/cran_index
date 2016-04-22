require 'rails_helper'
require 'dcf'
require 'csv'

describe Package, type: :model do
  describe "#descriptions#revise" do
    let(:description_dcf) do
      description_dcf = %Q|Package: abc
Version: #{version}
Date: 2012­16­02
Title: Tools for Approximate Bayesian Computation (ABC)
Author: #{authors}
Maintainer: #{maintainer}
Depends: R (>= 2.10), MASS, nnet, quantreg, locfit
Description: The package implements several ABC algorithms for
  performing parameter estimation and model selection.
  Cross­validation tools are also available for measuring the
  accuracy of ABC estimates, and to calculate the
  misclassification probabilities of different models.
Repository: CRAN
License: GPL (>= 3)
Packaged: 2012­08­14 15:10:43 UTC; mblum
Date/Publication: 2012­08­14 16:27:09
|
      Dcf.parse(description_dcf).first
    end
    let(:version) { "1.6" }
    let(:authors) { "Katalin Csillery" }
    let(:maintainer_name) { "Michael Blum" }
    let(:maintainer) { "#{maintainer_name} <michael.blum@imag.fr>" }

    let(:package) { Package.make! }

    context "when no description with same version exists" do
      it "creates description" do
        expect {
          package.descriptions.revise(description_dcf)
        }.to change {
          package.descriptions.size
        }.by(1)
      end

      subject(:actual) do
        package.descriptions.revise(description_dcf)
      end

      it "creates description with given attributes" do
        expect(actual.version).to eq(version)
      end
      it "creates authors with give attributes" do
        expect(actual.authors.map(&:name)).to match_array(authors.split(','))
      end
      it "creates maintainers with given attributes" do
        expect(actual.maintainers.map(&:name)).to match_array([maintainer_name])
      end
    end

    context "when description with same version exists" do
      let!(:description) do
        package.descriptions.make!(version: version)
      end

      it "doesn't create description" do
        expect {
          package.descriptions.revise(description_dcf)
        }.not_to change {
          package.descriptions.size
        }
      end

      it "doesn't change description" do
        expect(package.descriptions).to match_array([description])
      end
    end
  end

  describe "#replace_current_description_with(new_description)" do
    let(:package) { Package.make! }
    let(:current_version) { "1.1.1" }

    context "when package doesn't have existing description" do
      let(:new_version) { "1.2.1" }
      let!(:new_description) do
        package.descriptions.make!(version: new_version)
      end

      before do
        package.replace_current_description_with(new_description)
      end

      it "sets current_description with new_description" do
        expect(package.current_description).to eq(new_description)
      end
    end

    context "when package has existing descriptions" do
      context "and version of new description is higher than the existings" do
        let(:new_version) { "1.2.1" }
        let!(:current_description) do
          package.descriptions.make!(version: current_version).tap {|description|
            package.update_attribute(:current_description, description)
          }
        end
        let!(:new_description) do
          package.descriptions.make!(version: new_version)
        end

        before do
          package.replace_current_description_with(new_description)
        end

        it "replaces current_description with new_description" do
          expect(package.current_description).to eq(new_description)
        end
      end

      context "and version of new description is lower than the existings" do
        let(:new_version) { "1.0.1" }
        let!(:current_description) do
          package.descriptions.make!(version: current_version).tap {|description|
            package.update_attribute(:current_description, description)
          }
        end
        let!(:new_description) do
          package.descriptions.make!(version: new_version)
        end

        before do
          package.replace_current_description_with(new_description)
        end

        it "doesn't replace current_description with new_description" do
          expect(package.current_description).to eq(current_description)
        end
      end
    end
  end

  describe ".revise" do
    let(:package_name) { "A3" }
    let(:new_version) { "1.1.1" }

    before do
      dcf = { Package: package_name,
              Version: new_version
            }.with_indifferent_access
      allow(Package).
        to receive(:packages_dcf).
        and_return([dcf])

      allow(Description).
        to receive(:fetch_dcf).
        and_return(dcf)
    end

    context "when same package exists" do
      let!(:package) do
        Package.make!(name: package_name).tap { |package|
          package.update_attribute(
            :current_description,
            package.descriptions.make!(version: current_version)
          )
        }
      end

      before { Package.revise }

      subject(:version_of_current_description) do
        package.reload.current_description.version
      end

      context "and its version is different" do
        let(:current_version) { "1.0.0" }

        it "updates current_description" do
          expect(version_of_current_description).to eq(new_version)
        end
      end

      context "and its version is same" do
        let(:current_version) { new_version }

        it "updates current_description" do
          expect(version_of_current_description).to eq(current_version)
        end
      end
    end

    context "when same package doesn't exist" do
      before { Package.revise }

      subject(:created) do
        Package.where(name: package_name)
      end

      it "creates pacakge" do
        expect(created.exists?).to be_truthy
      end
      it "updates current_description" do
        expect(created.first.current_description.version).to eq(new_version)
      end
    end
  end
end
