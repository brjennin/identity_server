require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /api/v1/auth/login" do
    let(:user) { create(:user) }
    subject { post "/api/v1/authentication", params: credentials, headers: json_only_headers }

    context "with a valid email and password" do
      let(:credentials) {
        {
          email: user.email,
          password: user.password
        }.to_json
      }

      it "returns an authentication token" do
        subject
        expect(json["auth_token"]).to_not be_nil
      end
    end

    context "with an invalid password" do
      let(:credentials) {
        {
          email: user.email,
          password: FFaker::Internet.password
        }.to_json
      }

      it "returns a failure message" do
        subject
        expect(json["message"]).to match("Invalid credentials")
      end
    end

    context "with an invalid email and password" do
      let(:credentials) {
        {
          email: FFaker::Internet.email,
          password: FFaker::Internet.password
        }.to_json
      }

      it "returns a failure message" do
        subject
        expect(json["message"]).to match("Invalid credentials")
      end
    end
  end
end
