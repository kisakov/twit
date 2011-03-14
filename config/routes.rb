ActionController::Routing::Routes.draw do |map|
   map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'direct_messages'
  map.resources :direct_messages
  map.resources :statuses, :collection => {:mentions => :get, :favorites => :get},
                            :member => {:fav => :post, :unfav => :post}
  map.resource :session

  map.callback_session 'session/callback', :controller => 'sessions', :action => 'callback'


end
