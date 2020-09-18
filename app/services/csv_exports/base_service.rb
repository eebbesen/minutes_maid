# frozen_string_literal: true

module CsvExports
  #
  # Base CSV export service
  #
  class BaseService
    require 'csv'

    #
    # Initialise CSV export
    #
    # @param [collection] collection
    # @param [array] csv_columns
    #
    def initialize(collection, csv_columns = nil)
      @collection = collection
      @csv_columns = csv_columns
    end

    #
    # Generate CSV
    #
    # @return [csv]
    #
    def to_csv
      CSV.generate(headers: true) do |csv|
        csv << column_names
        if iterable?(collection)
          collection.each do |item|
            csv << data(item)
          end
        else
          csv << data(collection)
        end
      end.encode('cp1252', invalid: :replace, undef: :replace, replace: '?').force_encoding('UTF-8')
    end

    private

    attr_reader :collection, :csv_columns

    #
    # Check if collection is provided
    #
    # @param [object] object
    #
    # @return [boolean]
    #
    def iterable?(object)
      object.respond_to?(:each)
    end

    #
    # Column names used for CSV headers
    #
    # @return [array]
    #
    def column_names
      if csv_columns.blank? && collection.present?
        collection.first.class.column_names
      elsif csv_columns.present?
        csv_columns
      end
    end

    #
    # Format the CSV row
    #
    # @param [object] item
    #
    # @return [array]
    #
    def data(item)
      data = []
      column_names.each do |column|
        data << item.public_send(column)
      end
      data
    end
  end
end