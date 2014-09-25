RedmineApp::Application.routes.draw do
  resources :admin_monitor_alerts

  scope "/admin_monitor_alerts/:id" do
    get 'issue', :to => 'admin_monitor_alerts#issue'
    get 'handle', :to => 'admin_monitor_alerts#handle'
    get 'silent', :to => 'admin_monitor_alerts#silent'
  end
end
