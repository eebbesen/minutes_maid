json.extract! meeting, :id, :name, :date, :details, :agenda, :minutes, :string, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)
