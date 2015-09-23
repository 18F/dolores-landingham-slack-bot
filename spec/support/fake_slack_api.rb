require "sinatra/base"

class FakeSlackApi < Sinatra::Base
  cattr_accessor :failure

  post "/api/chat.postMessage" do
    if failure
      json_response 200, "message_post_failure.json"
    else
      json_response 200, "message_posted.json"
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
