# frozen_string_literal: true

json.array! @notes, partial: 'notes/note', as: :note
