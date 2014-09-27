module RedmineAdminMonitor
  module Patches
    module ApplicationControllerPatch
      def self.included(base) 
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do   
          rescue_from Exception, :with => :render_500 
        end
      end 
    end
    module ClassMethods
    end
    module InstanceMethods

      def render_500(options={})
        message = :notice_internal_error
        unless Rails.application.config.consider_all_requests_local
          AdminMonitorAlert.update_or_create({:user_id => User.current.id,
            :project_id => @project ? @project.id : nil ,
            :alert_type => options.class.name ,
            :message => options.message ,
            :source => params ? params[:controller] : "",
            :action => params ? params[:action] : "",
            :backtrace => options.backtrace,
            :params => params })
          message = (["<h2> Oops! You've found our error page </h2>","<h3>#{l(:notice_internal_error)}</h3>"]).join("</br>").html_safe  
        else
          params_msg = []
          if params
            params_msg << "</br><b>Params:</b>"
            params_msg += params.collect{|k,v| "#{k}: #{v}"}
          end  
          message = (["<h2> Oops! You've found our error page </h2>","<b>Message:</b> #{options.message}"] + params_msg + ["</br><b>Backtrace:</b>"] + options.backtrace ).join("</br>").html_safe if (options.message && options.backtrace)  
        end
        render_error({:message => message , :status => 500})
        return false
      end
      
    end
  end
end
