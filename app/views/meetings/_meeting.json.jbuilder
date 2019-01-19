# frozen_string_literal: true

json.extract! meeting, :id, :name, :date, :details, :agenda, :minutes, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)
