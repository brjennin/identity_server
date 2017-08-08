require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /api/v1/auth/login" do
    let(:headers) { valid_headers("213").except("Authorization") }
    let(:credentials) {
      {
        email: FFaker::Internet.email,
        password: FFaker::Internet.password
      }.to_json
    }
    subject { post "/api/v1/auth/login", params: credentials, headers: headers }

    context "with a valid email and password" do
      before do
        allow(Authenticator).to receive(:token_for_login).and_return("token")
        subject
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
