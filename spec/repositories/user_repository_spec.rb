require "rails_helper"

RSpec.describe UserRepository do
  describe ".find" do
    subject { described_class.find(id) }
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    context "when there is a user with the id" do
      let(:id) { user.id }

      it "returns the user" do
        expect(subject).to eq(user)
      end
    end

    context "when there is NOT a user with the id" do
      let(:id) { 485 }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end

  describe ".find_by_email" do
    subject { described_class.find_by_email(email) }
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    context "when there is a user with the email" do
      let(:email) { user.email }

      it "returns the user" do
        expect(subject).to eq(user)
      end
    end

    context "when there is NOT a user with the email" do
      let(:email) { "@@" }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
