class DirectMessagesController < ApplicationController
  before_filter :authenticate

  #caches_page :index
  caches_action :messages
  
  def index
    @direct_messages = Hash.new
    #dm = client.direct_messages | client.direct_messages_sent

    (client.direct_messages | client.direct_messages_sent).each do |msg|
      if client.user.screen_name == msg.recipient_screen_name
        @direct_messages[msg.sender.screen_name] = @direct_messages[msg.sender.screen_name].to_a << msg
      else
        @direct_messages[msg.recipient.screen_name] = @direct_messages[msg.recipient.screen_name].to_a << msg
      end
    end
  end

  def messages

    @name = params[:id]
    @direct_messages = Hash.new
    
    (client.direct_messages | client.direct_messages_sent).each do |msg|
      if client.user.screen_name == msg.recipient_screen_name
        @direct_messages[msg.sender.screen_name] = @direct_messages[msg.sender.screen_name].to_a << msg if @name == msg.sender.screen_name
      else
        @direct_messages[msg.recipient.screen_name] = @direct_messages[msg.recipient.screen_name].to_a << msg if @name == msg.recipient.screen_name
      end
    end
    
    @arr=@direct_messages[@name].to_a
    @direct_messages[@name]=@arr.sort_by {|a| a.id}.reverse!

  end

  def refr
    expire_action :action => :messages, :id => params[:id]
    redirect_to :action => :messages, :id => params[:id]
  end

  def create

    client.direct_message_create(params[:id], params[:text])
    flash[:notice] = "The message will be sent to #{params[:id]}"
    redirect_to :action => :refr, :id => params[:id]
    #@id_user = params[:id]
    #@text = params[:text]
  end

  def destroy
    client.direct_message_destroy(params[:msg_id])
    flash[:notice] = "The message will be destroyed!"
    redirect_to :action => :refr, :id => params[:id]
    #@id_user = params[:id]
    #@text = params[:text]
  end

end
