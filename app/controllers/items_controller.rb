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

    respond_to do |format|
      format.html
      format.csv { process_csv_file(export_as_csv) }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def export_as_csv
    CsvExports::ItemsExportService.new(@items, 'index').to_csv
  end

  def process_csv_file(csv)
    date_time = DateTime.now.to_s
    send_data csv,
              type: 'text/csv; charset=iso-8859-1; header=present',
              disposition: 'attachment',
              filename: 'items_including_notes_' + date_time + '.csv'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:file_number, :version, :name, :item_type, :title, :action, :result, :meeting_id)
  end
end
