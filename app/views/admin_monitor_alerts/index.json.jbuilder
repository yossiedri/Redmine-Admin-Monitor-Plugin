json.array!(@admin_monitor_alerts) do |tracker_default_estimation|
  json.extract! tracker_default_estimation, :id, :tracker_id, :project_id, :estimated_hours
  json.url tracker_default_estimation_url(tracker_default_estimation, format: :json)
end
