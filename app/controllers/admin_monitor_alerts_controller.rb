class AdminMonitorAlertsController < ApplicationController

  before_filter :set_admin_monitor_alert, only: [:edit, :update, :destroy,:issue,:handle,:silent]
  before_filter :set_project 

  helper :admin_monitor_alerts
  include AdminMonitorAlertsHelper

  def issue

    begin

      raise "Issue already exist!!" if @admin_monitor_alert.issue_id

      @issue = Issue.create!({:author_id => User.current.id,
       :project_id => 100,
       :assigned_to_id => User.current.id,
       :subject=> "#{@admin_monitor_alert.alert_type} in #{@admin_monitor_alert.source} on #{@admin_monitor_alert.action}",
       :tracker_id => 1,
       :description => prity_stack(@admin_monitor_alert.message,@admin_monitor_alert.backtrace) })

      @admin_monitor_alert.update_attributes({:issue_id => @issue.id})
      
      result = [@admin_monitor_alert.id,@admin_monitor_alert.issue_id]

    rescue Exception => e
      result = [e.message]  
    end

    respond_to do |format|
      format.json { render :json => {:response => result}}
    end

  end  


  def handle
    respond_to do |format|
      if @admin_monitor_alert.update_attributes({:handle_flag => params[:handle_flag]})
        format.html { redirect_back_or_default admin_monitor_alerts_path }
        format.json { render :json => {:response => [@admin_monitor_alert.id,@admin_monitor_alert.handle_flag]}}
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_monitor_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def silent
      
      if @admin_monitor_alert.update_attributes({:silent_flag => params[:silent_flag]})
        render :json => {:response => [@admin_monitor_alert.id,@admin_monitor_alert.silent_flag]}
      else
        render json: @admin_monitor_alert.errors, status: :unprocessable_entity
      end
      
  end

  def index
    @conditions = params[:conditions] || ""
    @pages, @admin_monitor_alerts = paginate :admin_monitor_alert,
    :per_page => 15 ,
    :conditions => @conditions.blank? ? '' : "#{AdminMonitorAlert.table_name}.handle_flag = #{@conditions}" , 
    :order => "#{AdminMonitorAlert.table_name}.created_on DESC"
  end

  def new
    @admin_monitor_alert = AdminMonitorAlert.new
  end

  def edit
  end
  
  def create
    @admin_monitor_alert = AdminMonitorAlert.new(admin_monitor_alert_params)

    respond_to do |format|
      if @admin_monitor_alert.save
        format.html { redirect_to admin_monitor_alerts_path, notice: 'Admin alert was successfully created.' }
        format.json { render action: 'edit', status: :created, location: @admin_monitor_alert }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_monitor_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_monitor_alert.update_attributes(admin_monitor_alert_params)
        format.html { redirect_to admin_monitor_alerts_path , notice: 'Admin alertwas successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_monitor_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_monitor_alert.destroy
    respond_to do |format|
      format.html { redirect_to admin_monitor_alerts_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_monitor_alert
      @admin_monitor_alert = AdminMonitorAlert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_monitor_alert_params
      admin_monitor_alert = params[:admin_monitor_alert]
      raise "Params missing error" if admin_monitor_alert.blank?
      
      if params[:action].eql?('update') && !admin_monitor_alert[:backtrace].blank?
        admin_monitor_alert[:backtrace] = admin_monitor_alert[:backtrace].split("\r\n")
      elsif admin_monitor_alert[:backtrace].blank?
        admin_monitor_alert[:backtrace] = []
      end  
      
      {:user_id => admin_monitor_alert[:user_id] , :project_id => admin_monitor_alert[:project_id] , :issue_id => admin_monitor_alert[:issue_id] ,
        :alert_type => admin_monitor_alert[:alert_type] , :source => admin_monitor_alert[:source] , :action => admin_monitor_alert[:action] ,
        :message => admin_monitor_alert[:message] , :backtrace => admin_monitor_alert[:backtrace] ,
        :handle_flag => admin_monitor_alert[:handle_flag] ,:silent_flag => admin_monitor_alert[:silent_flag] }

      end

      def set_project
        @project = Project.find(params[:project_id]) unless params[:project_id].blank?
      end

    end
