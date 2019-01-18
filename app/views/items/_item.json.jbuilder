json.extract! item, :id, :file_number, :version, :name, :item_type, :title, :action, :result, :meeting_id, :created_at, :updated_at
json.url item_url(item, format: :json)
