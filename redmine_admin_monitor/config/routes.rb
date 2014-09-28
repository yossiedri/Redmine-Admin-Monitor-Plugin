resources :admin_monitor_alerts

match 'admin_monitor_alerts/:id/issue', :to => 'admin_monitor_alerts#issue', :via => 'get'
match 'admin_monitor_alerts/:id/handle', :to => 'admin_monitor_alerts#handle', :via => 'get'
match 'admin_monitor_alerts/:id/silent', :to => 'admin_monitor_alerts#silent', :via => 'get'

