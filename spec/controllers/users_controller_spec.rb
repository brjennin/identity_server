require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "#create" do
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }
    let(:password_confirmation) { FFaker::Internet.password }
    let(:params) {
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      }
    }
    subject { post :create, params: params, format: :json }

    context "valid user params" do
      let(:user) { double(User, email: "email@example.com", password: "password") }
      before do
        allow(UserRepository).to receive(:create).and_return(user)
        allow(Authenticator).to receive(:token_for_login).and_return("token")
        subject
      end

      it "creates a user" do
        expect(UserRepository).to have_received(:create).with(email, password, password_confirmation)
      end

      it "calls the authenticator" do
        expect(Authenticator).to have_received(:token_for_login).with("email@example.com", "password")
      end

      it "returns an authentication token" do
        expect(json["auth_token"]).to eq("token")
      end
    end

    context "with an invalid email and password" do
      before do
        allow(UserRepository).to receive(:create).and_raise(ActiveRecord::RecordInvalid.new())
        subject
      end

      it "returns a failure message" do
        expect(json["message"]).to match("Record invalid")
      end
    end
  end

  describe "#show" do
    subject {
      get :show, params: {}, format: :json
    }

    context "when a current user can be found" do
      let(:user) { double(User, as_json: {'test': 'value'}) }

      before do
        allow(ApiGatekeeper).to receive(:verify_user).and_return(user)
        subject
      end

      it "calls the api gatekeeper" do
        expect(ApiGatekeeper).to have_received(:verify_user).with(request.headers)
      end

      it "is successful" do
        expect(response).to be_success
      end

      it "returns an authentication token" do
        expect(json).to eq({'test' => 'value'})
      end
    end

    context "when a current user can't be found" do
      before do
        allow(ApiGatekeeper).to receive(:verify_user).and_raise(ExceptionHandler::InvalidToken)
        subject
      end

      it "calls the api gatekeeper" do
        expect(ApiGatekeeper).to have_received(:verify_user).with(request.headers)
      end

      it "gives a 401 error code" do
        expect(response.status).to eq(422)
      end

      it "returns an authentication token" do
        expect(json).to eq({'message' => 'ExceptionHandler::InvalidToken'})
      end
    end
  end
end
