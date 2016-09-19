require "rails_helper"

describe BroadcastMessagesController do
  describe "GET :new" do
    it "redirects if the user is not an admin" do
      user = create(:user, admin: false)
      allow(controller).to receive(:current_user).and_return(user)

      get :new

      expect(response).to redirect_to root_path
      expect(flash[:error]).to be_present
    end
  end

  describe "POST :create" do
    it "redirects if the user is not an admin" do
      user = create(:user, admin: false)
      allow(controller).to receive(:current_user).and_return(user)

      post :create, broadcast_message: { title: "t", body: "b" }

      expect(response).to redirect_to root_path
      expect(flash[:error]).to be_present
    end
  end
end
