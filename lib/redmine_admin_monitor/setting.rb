module RedmineAdminMonitor
  class Setting

    def self.default_project_id
      ::Setting.plugin_redmine_admin_monitor[:default_project_id]
    end
    
    def self.default_tracker_id
      ::Setting.plugin_redmine_admin_monitor[:default_tracker_id]
    end

  end
end
