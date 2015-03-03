module AdminMonitorAlertsHelper

	def pretty_array_string(messages)
		unless messages.blank?
			messages.join("\n").html_safe
		else
			""	
		end	
	end

	def condition_colored(cnd,param)

		case cnd
		
		when "Handled"
			style = param.eql?('true') ? "font-weight:bold" : ""
		when "Not Handled"
			style = param.eql?('false')	? "font-weight:bold" : ""
		when 'All'
			style = param.eql?('') ? "font-weight:bold" : ""
		end

		content_tag('span',cnd,:style => style) 
	end	

	def small_backtrace(backtrace)
		unless backtrace.blank?
			backtrace[0..2].join("\n").html_safe
		else
			[]
		end	
	end	

	def prity_stack(message = "",backtrace=[])
		([message] + backtrace).join("\n").html_safe
	end


	def background_color(alert)
		
		return "" if alert.handle_flag
		
		diff = (Time.now - alert.created_on)

		case 
		when diff < 8.hours
			"#dfffdf"
		when diff < 16.hours
			"#ffe740"	
		else
			"#ff4040"
		end

	end


	def legend
		style = "border-radius: 8px;width: 20px;height: 15px;border-color: grey;border-width: thin;border-style: inherit;"
		s = '<table><tr>'
		s << content_tag('td',content_tag(:div,'',:style => "#{style};background-color: #dfffdf;"))
		s << content_tag('td',label_tag("< 8 hours ago"))
		s << content_tag('td',content_tag(:div,'',:style => "#{style};background-color: #ffe740;"))
		s << content_tag('td',label_tag("< 16 hours ago"))
		s << content_tag('td',content_tag(:div,'',:style => "#{style};background-color: #ff4040;"))
		s << content_tag('td',label_tag(" > 16 hours ago"))
		s << '</tr></table>'
		s.html_safe
	end

	def link_issue(issue_id)
		unless issue_id.nil?
			return  link_to issue_id, issue_path(issue_id)
		end	
		""	
	end

	def create_issue(alert)
		if alert.issue_id.nil?
			link_to image_tag('add.png', :title => "Create Issue!") , {:remote => true , :controller => :admin_monitor_alerts , :action => :issue , :id => alert.id} , {:id => "admin_monitor_alerts_to_issue_#{alert.id}"  ,:class => "admin_monitor_alerts_to_issue"}
		else
			link_to image_tag('duplicate.png', :title => "Go to Issue!") , issue_path(alert.issue_id)	
		end	
	end

	def toggel_handle(alert)
		if alert.handle_flag
			return link_to image_tag('false.png', :title => "UnHandle!") , {:remote => false , :controller => :admin_monitor_alerts , :action => :handle , :id => alert.id , :handle_flag => false } , {:id => "admin_monitor_alerts_handle_flag_#{alert.id}"  ,:class => "admin_monitor_alerts_handle_flag"}							
		else	
			return link_to image_tag('true.png', :title => "Handle!") , {:remote => false , :controller => :admin_monitor_alerts , :action => :handle , :id => alert.id , :handle_flag => true } , {:id => "admin_monitor_alerts_handle_flag_#{alert.id}"  ,:class => "admin_monitor_alerts_handle_flag"}	
		end	
	end	
	
	def toggel_silent(alert)
		if alert.silent_flag
			return link_to image_tag('../plugin_assets/redmine_admin_monitor/images/silent.png', :title => "Click to enable mail alert for this error") , {:remote => true , :controller => :admin_monitor_alerts , :action => :silent , :id => alert.id , :silent_flag => false } , {:id => "admin_monitor_alerts_silent_flag_#{alert.id}"  ,:class => "admin_monitor_alerts_silent_flag"}							
		else	
			return link_to image_tag('../plugin_assets/redmine_admin_monitor/images/unsilent.png', :title => "Click to disable mail alert for this error") , {:remote => true , :controller => :admin_monitor_alerts , :action => :silent , :id => alert.id , :silent_flag => true } , {:id => "admin_monitor_alerts_silent_flag_#{alert.id}"  ,:class => "admin_monitor_alerts_silent_flag"}	
		end	
	end	


	def time_ago_tag(time)
		text = distance_of_time_in_words(Time.now, time)
		content_tag('p', text, :title => format_time(time))
	end

end






