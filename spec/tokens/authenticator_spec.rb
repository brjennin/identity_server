require 'rails_helper'

RSpec.describe Authenticator do
  describe ".token_for_login" do
    subject { described_class.token_for_login(email, password) }
    let(:email) { "email@example.com" }
    let(:password) { "password" }

    before do
      allow(UserRepository).to receive(:find_by_email).and_return(found_user)
    end

    context "when email doesn't exist" do
      let(:found_user) { nil }

      it "raises an authentication error" do
        expect { subject }.to raise_error(ExceptionHandler::AuthenticationError, "Invalid credentials")
      end
    end

    context "when email exists" do
      let(:found_user) { double(User, id: 38484) }

      before do
        allow(found_user).to receive(:authenticate).and_return(valid_password)
      end

      context "when password matches" do
        let(:valid_password) { true }

        before do
          allow(WebTokenManager).to receive(:encode).and_return("token")
        end

        it "returns the token" do
          expect(subject).to eq("token")
        end

        it "encodes a token" do
          subject
          expect(WebTokenManager).to have_received(:encode).with({ user_id: 38484 })
        end
      end

      context "when password doesn't match" do
        let(:valid_password) { false }

        it "raises an authentication error" do
          expect { subject }.to raise_error(ExceptionHandler::AuthenticationError, "Invalid credentials")
        end
      end
    end
  end
end
