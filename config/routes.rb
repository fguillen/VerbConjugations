ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'verbs', :action => 'search'
  map.verb '/:q', :controller => 'verbs', :action => 'show'
end
