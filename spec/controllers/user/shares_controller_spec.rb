require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe User::SharesController, type: :controller do
  context "A user is signed in and has an existing share" do
    let(:user) { FactoryBot.create(:user) }
    let(:user_share) { FactoryBot.create(:user_share, user: user) }
    let(:invalid_attributes) { { user_id: nil } }

    before do
      sign_in user
      user_share
    end

    describe "GET #index" do
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: user_share.to_param}
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        get :edit, params: {id: user_share.to_param}
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        let(:valid_attributes) do
          FactoryBot.build(
            :user_share, 
            user: user, 
            recipient: FactoryBot.create(:organisation_user),
            birth_record: FactoryBot.create(:birth_record)
            ).attributes
          end

        it "creates a new Share" do
          expect {
            post :create, params: { share: valid_attributes}
          }.to change(User::Share, :count).by(1)
        end

        it "redirects to the created share" do
          post :create, params: {share: valid_attributes}
          expect(response).to redirect_to(User::Share.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {share: invalid_attributes}
          expect(response).to be_successful
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let!(:valid_attributes) { user_share.attributes.except("id", "created_at", "updated_at") }
        let!(:new_attributes) { FactoryBot.create(:user_share).attributes.except("id", "created_at", "updated_at") }

        it "updates the requested share" do
          put :update, params: {id: user_share.to_param, share: new_attributes}
          user_share.reload
          model_attributes = user_share.attributes.except("id", "created_at", "updated_at")
          expect(model_attributes).to match(new_attributes)
          expect(model_attributes).to_not match(valid_attributes)
        end

        it "redirects to the share" do
          put :update, params: {id: user_share.to_param, share: valid_attributes}
          expect(response).to redirect_to(user_share)
        end
      end

      context "with invalid params" do
        it "raises an exception" do
          expect {
            put :update, params: {id: user_share.to_param, share: invalid_attributes}
          }.to raise_error(ActiveRecord::NotNullViolation)

        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested share" do
        expect {
          delete :destroy, params: {id: user_share.to_param}
        }.to change(User::Share, :count).by(-1)
      end

      it "redirects to the shares list" do
        delete :destroy, params: {id: user_share.to_param}
        expect(response).to redirect_to(user_shares_url)
      end
    end
  end
end
