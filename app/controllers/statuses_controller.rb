class StatusesController < ApplicationController
  before_filter :authenticate


  def index
    @tweets = client.friends_timeline()
    @followers = client.followers
    @friends = client.friends
    @user = client.user

  end


end
