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

  describe ".create" do
    context "with valid date" do
      subject { described_class.create("hunk@69.com", "password", "password") }

      it "creates a new user" do
        expect { subject }.to change { User.count }.by(1)
      end

      it "returns the user" do
        record = subject
        expect(record).to be_a_kind_of(User)
        expect(record.email).to eq("hunk@69.com")
        expect(record.password).to eq("password")
        expect(record.password_confirmation).to eq("password")
      end

      it "puts an item in the database" do
        expect(subject).to be_persisted
        expect(subject).to eq(User.last)
      end
    end

    context "with invalid data" do
      subject { described_class.create("hunk@69.com", "password", "nope") }

      it "raises an exception" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
