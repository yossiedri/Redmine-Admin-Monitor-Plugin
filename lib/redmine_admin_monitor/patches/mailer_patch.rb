module RedmineAdminMonitor
  module Patches
    module MailerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
      end 
    end

    module InstanceMethods

      def alert_error_message(alert)
        redmine_headers 'AdminMonitorAlert' => alert.source,'AdminMonitorAlert-Id' => alert.id
        recipients = ["name@company.com"]
        cc = ["name@company.com"]
        subject = "Admin Monitor Alert: [Alert Type #{alert.alert_type.titleize} frome #{alert.source.titleize}]  Action: #{alert.action.titleize}"
        
        @alert = alert
        @id =  alert.id
        @alert_type =  alert.alert_type
        @user =  (alert.user && alert.user.name) ?  alert.user.name : ""
        @project =  (alert.project && alert.project.name) ?  alert.project.name : ""
        @message = alert.message 
        @source =  alert.source
        @action =  alert.action
        @created_on = alert.created_on
        @params =  alert.params
        @backtrace =  alert.backtrace
        
        @url = url_for(:controller => 'admin_monitor_alerts', :action => 'edit', :id => @id ) #,:host => HOST, :port => PORT)
        
        mail :to => recipients, :cc => cc, :subject => subject
      end
    end
  end
end

