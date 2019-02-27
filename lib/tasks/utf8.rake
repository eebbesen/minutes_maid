# frozen_string_literal: true

desc 'fix utf8 issues in database'
task fix_utf8: :environment do
  # RIGHT SINGLE QUOTATION MARK from ISO-8859-1
  ii = Item.where("title like '%â\u0080\u0099%'")
  ii.each do |i|
    i.title = ItemsHelper.utf8_convert(i.title)
    i.save!
  end
end
