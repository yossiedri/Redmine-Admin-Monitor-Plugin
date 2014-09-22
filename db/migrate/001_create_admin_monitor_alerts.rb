class CreateAdminMonitorAlerts < ActiveRecord::Migration
  def change
    create_table :admin_monitor_alerts do |t|

      t.column :user_id, :integer
      t.column :project_id, :integer
      t.column :alert_type, :string
      t.column :source, :string
      t.column :action, :string
      t.column :message, :text
      t.column :backtrace, :text
      t.column :counter, :integer, :default => 0
      t.column :issue_id, :integer, :default => nil
      t.column :silent_flag , :boolean , :default => false
      t.column :params , :text
      t.column :handle_flag, :boolean, :default => false
      t.column :created_on, :datetime, :null => false
      t.column :updated_on, :datetime, :null => false

    end
  end
end
