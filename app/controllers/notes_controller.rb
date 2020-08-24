# frozen_string_literal: true

##
class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /notes
  # GET /notes.json
  def index
    if params['item_id']
      @item = Item.find(params['item_id'])
      @notes = Note.where(user_id: current_user.id, item_id: @item.id)
    else
      @notes = Note.all.where(user_id: current_user.id)
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def shows; end

  # GET /notes/new
  def new
    @item = Item.find(params['item_id'])
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit; end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params.merge("user_id": current_user.id))

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params.merge("user_id": current_user.id))
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def note_params
    params.require(:note).permit(:text, :item_id)
  end
end
