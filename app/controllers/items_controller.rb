# frozen_string_literal: true

##
class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # GET /items
  # GET /items.json
  def index
    @items = if params[:meeting_id]
               Item.where(meeting_id: params[:meeting_id]).order(:item_type)
             else
               Item.all.sort_by { |i| i.meeting.date }.reverse
             end.reject { |i| i.file_number.nil? }
  end

  # GET /items/1
  # GET /items/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:file_number, :version, :name, :item_type, :title, :action, :result, :meeting_id)
  end
end
