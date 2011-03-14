class DirectMessagesController < ApplicationController
  before_filter :authenticate

  def self.load_friends(client, user)
    friends = Hash.new

    (client.direct_messages(:count => 200) | client.direct_messages_sent(:count => 200)).each do |msg|
      if user.screen_name == msg.recipient_screen_name
        friends[msg.sender.screen_name] = msg.sender
      else
        friends[msg.recipient.screen_name] = msg.recipient
      end
    end
    return friends
  end

  def self.load_messages(client, name, user)
    direct_messages = Array.new

    (client.direct_messages(:count => 200) | client.direct_messages_sent(:count => 200)).each do |msg|
      if (( name == msg.sender.screen_name && user.screen_name == msg.recipient.screen_name ) ||
          ( user.screen_name == msg.sender.screen_name && name == msg.recipient.screen_name ))
        msg["message_type"] = "direct"
        direct_messages << msg
      end
    end

    client.mentions(:count => 200).each do |msg|
      if name == msg.user.screen_name
        msg["message_type"] = "mention"
        msg["sender"] = msg["user"]
        direct_messages << msg
      end
    end

    time_line = client.user_timeline(user.screen_name, :count => 200)
    time_line.each do |msg|
      if name == msg.in_reply_to_screen_name
        msg["message_type"] = "mention"
        msg["sender"] = msg["user"]
        direct_messages << msg
      end
    end


    direct_messages.sort_by {|a| a.created_at = a.created_at[4..18] + a.created_at[25..29] }.reverse!
  end

  def index
    @friends = Rails.cache.fetch("#{session['user'].id}_friends") { DirectMessagesController.load_friends(client, session['user']) }
  end

  def messages
    @name = params[:id]
    @direct_messages = Rails.cache.fetch("#{session['user'].id}_direct_messages_#{params[:id]}") { DirectMessagesController.load_messages(client, params[:id], session['user']) }
  end

  def refr
    Rails.cache.delete("#{session['user'].id}_direct_messages_#{params[:id]}")
    redirect_to :action => :messages, :id => params[:id]
  end

  def create
    client.direct_message_create(params[:id], params[:text])
    flash[:notice] = "The message will be sent to #{params[:id]}"
    redirect_to :action => :refr, :id => params[:id]
  end

  def destroy
    client.direct_message_destroy(params[:msg_id])
    flash[:notice] = "The message will be destroyed!"
    redirect_to :action => :refr, :id => params[:id]
  end

  def mentions
    @time_line = client.user_timeline(session['user'].screen_name, :count => 200)
    #@mentions = Twitter::Search.new.mentioning("DiTeam").fetch
  end

end
