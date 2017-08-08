require "rails_helper"

RSpec.describe "Sign up", type: :request do
  describe "POST /signup" do
    before do
      post "/api/v1/signup", params: params.to_json, headers: json_only_headers
    end

    context "when valid request" do
      let(:params) {
        {
          email: "hunk@thehunk.com",
          password: "6969",
          password_confirmation: "6969",
        }
      }

      it "creates a new user" do
        expect(response).to have_http_status(201)
      end
      
      it "returns an authentication token" do
        expect(json["auth_token"]).not_to be_nil
      end
    end

    context "when invalid request" do
      let(:params) { {} }

      it "does not create a new user" do
        expect(response).to have_http_status(422)
      end

      it "returns failure message" do
        expect(json["message"]).to match(/Validation failed: Password can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end
end
