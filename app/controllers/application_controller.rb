# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Twitter::AuthenticationHelpers

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  rescue_from Twitter::Unauthorized, :with => :force_sign_in

  private

  def oauth_consumer
    @oauth_consumer ||= OAuth::Consumer.new("KxYLpI8qtjEsPesiwXouwA", "M3E3hxdO6KfGqsierNYNYUB6uCgjMrCMwrfaQaOLn4o",
                                            :site => 'http://api.twitter.com', :request_endpoint => 'http://api.twitter.com', :sign_in => true)
  end

    def client
      Twitter.configure do |config|
        config.consumer_key = "KxYLpI8qtjEsPesiwXouwA"
        config.consumer_secret = "M3E3hxdO6KfGqsierNYNYUB6uCgjMrCMwrfaQaOLn4o"
        config.oauth_token = session['access_token']
        config.oauth_token_secret = session['access_secret']
      end
      @client ||= Twitter::Client.new
    end
    helper_method :client

    def force_sign_in(exception)
      reset_session
      flash[:error] = 'Seems your credentials are not good anymore. Please sign in again.'
      redirect_to new_session_path
    end
end
