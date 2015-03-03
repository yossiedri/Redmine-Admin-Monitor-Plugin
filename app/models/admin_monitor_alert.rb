
class AdminMonitorAlert < ActiveRecord::Base

	belongs_to :user
	belongs_to :project
	belongs_to :issue 

	serialize :backtrace, Array
	serialize :params, Array
	after_create :send_error_mail
	# after_update :send_error_mail 
	scope :alert_types , -> { select(:alert_type).group(:alert_type).pluck(:alert_type) }
	scope :alerts , -> { select("*") }

	attr_accessible :handle_flag,:backtrace,:user_id,:project_id,:issue_id,:alert_type,:source,:action,:message,:silent_flag

	def send_error_mail
		Mailer.deliver_alert_error_message(self) unless self.silent?
	end

	def silent?
		self.silent_flag
	end	
	
	def params=(value)
		if value.is_a? Hash
			write_attribute(:params, value.collect{|k,v| "#{k}: #{v}"})
		else
			write_attribute(:params, value)
		end 
	end	

	class << self

		def update_or_create(attr)
			alert = find_uniqe(attr[:alert_type],attr[:source],attr[:message])
			if alert.blank? 
				alert = AdminMonitorAlert.create!(attr)
			else
				alert.update_attributes({:counter => alert.counter + 1})
				alert.send_error_mail if alert.counter < 5 
			end  
			alert
		end

		private
		
		def find_uniqe(alert_type,source,message)
			AdminMonitorAlert.where(["alert_type = ? and source = ? and message like ? ",alert_type,source,uniq_msg(message)]).order(:created_on).first
		end

		def uniq_msg(message)

			return message if message.blank?

			if !message.scan('#<').blank?	
				message_arr = message.split('#<')
				return message_arr[0] << "%" unless message_arr.blank? || message_arr[0].blank?
			elsif !message.scan(': ').blank?
				message_arr = message.split(': ')
				message_arr.delete_at(message_arr.count-1) if message_arr.count > 1 	
				return message_arr.join(': ') << "%" unless (message_arr[0].blank? && message_arr.count == 1)
			end		
			message
		end

	end 
end