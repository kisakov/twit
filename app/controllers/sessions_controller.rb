class SessionsController < ApplicationController

  def new
    @user = client.user if signed_in?
  end

  def create
    #expire_page :controller => :direct_messages, :action => :index
    request_token = oauth_consumer.get_request_token(:oauth_callback => callback_session_url)
    session['request_token'] = request_token.token
    session['request_secret'] = request_token.secret
    #session['client_id'] = client.user.id
    redirect_to request_token.authorize_url
  end

  def destroy
    #expire_page :controller => :direct_messages, :action => :index
    reset_session
    #Rails.cache.clear
    redirect_to new_session_path
  end

  def callback
    request_token = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    reset_session
    session['access_token'] = access_token.token
    session['access_secret'] = access_token.secret
    user = client.verify_credentials
    sign_in(user)
    session['user'] = client.user
    redirect_back_or root_path
  end
end
