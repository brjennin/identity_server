require 'rails_helper'

RSpec.describe ApiGatekeeper do
  describe ".verify_user" do
    subject { described_class.verify_user(header) }

    context "with a user token" do
      let(:user) { double(User, id: 239) }

      context "with a non expired token" do
        let(:header) { valid_headers(user) }

        context "when user can't be found" do
          before do
            allow(UserRepository).to receive(:find).and_return(nil)
          end

          it "raises an InvalidToken error" do
            expect { subject }.to raise_error(ExceptionHandler::InvalidToken, "Invalid token")
          end
        end

        context "when the user can be found" do
          before do
            allow(UserRepository).to receive(:find).and_return(user)
          end

          it "looks up the user by id" do
            subject
            expect(UserRepository).to have_received(:find).with(239)
          end

          it "returns the user" do
            expect(subject).to eq(user)
          end
        end
      end

      context "when the token is expired" do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { subject }.to raise_error(ExceptionHandler::ExpiredSignature, "Signature has expired")
        end
      end
    end

    context "when token is missing" do
      let(:header) { invalid_headers }

      it "raises a MissingToken error" do
        expect { subject }.to raise_error(ExceptionHandler::MissingToken, "Missing token")
      end
    end
  end
end
