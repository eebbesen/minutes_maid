# frozen_string_literal: true

# decorate Item
module ItemsHelper
  class << self
    def loc_link(item)
      (item.item_type && item.item_type.starts_with?('Resolution LH') && !item.file_number.starts_with?('RLH AR')) ? Mappy.link(clean_name(item.name)) : ''
    end

    def clean_name(name)
      name.gsub('Remove/Repair', '').strip
    end
  end
end
