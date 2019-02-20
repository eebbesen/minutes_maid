# frozen_string_literal: true

class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show edit update destroy]

  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all.order(date: :desc).order(:name)
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def meeting_params
    params.require(:meeting).permit(:name, :date, :details, :agenda, :minutes)
  end
end
