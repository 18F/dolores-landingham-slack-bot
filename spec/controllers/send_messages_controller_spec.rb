require "rails_helper"

describe SendBroadcastMessagesController do
  describe "POST :create" do
    it "redirects if the user is not an admin" do
      user = create(:user, admin: false)
      allow(controller).to receive(:current_user).and_return(user)

      process :create, method: :post, params: { broadcast_message_id: 1 }

      expect(response).to redirect_to root_path
      expect(flash[:error]).to be_present
    end
  end
end
