require "rails_helper"

RSpec.describe AuthenticationController, type: :controller do
  describe "#create" do
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }
    let(:params) {
      {
        email: email,
        password: password,
      }
    }
    subject { post :create, params: params, format: :json }

    context "with a valid email and password" do
      before do
        allow(Authenticator).to receive(:token_for_login).and_return("token")
        subject
      end

      it "calls the authenticator" do
        expect(Authenticator).to have_received(:token_for_login).with(email, password)
      end

      it "returns an authentication token" do
        expect(json["auth_token"]).to eq("token")
      end
    end

    context "with an invalid email and password" do
      before do
        allow(Authenticator).to receive(:token_for_login).and_raise(ExceptionHandler::AuthenticationError.new("Invalid credentials"))
        subject
      end

      it "returns a failure message" do
        expect(json["message"]).to match("Invalid credentials")
      end
    end
  end
end
