# frozen_string_literal: true

require 'test_helper'

module Processor
  class SaintPaulTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('stp_legistar') do
        @p = Processor::SaintPaul.new
      end
    end

    test 'process' do
      VCR.use_cassette('stp_legistar_details_6EDC9EFD') do
        assert_difference('Meeting.count', 10) do
          assert_difference('Item.count', 345) do
            @p.process
          end
        end
      end
    end

    test 'gets meeting rows' do
      assert_equal 11, @p.get_meeting_rows.count
    end

    test 'gets meeting rows with pagination footer' do
      VCR.use_cassette('stp_legistar_pagination_footer') do
        p = Processor::SaintPaul.new
        assert_equal 100, p.get_meeting_rows.count
      end
    end

    test 'gets meeting detail rows' do
      m = @p.get_meeting_rows('City Council').first
      url = Processor::SaintPaul.extract_meeting_data(m)[:details]
      VCR.use_cassette('stp_legistar_details') do
        d = Processor::SaintPaul.get_meeting_detail_rows url

        assert_equal 25, d.count
      end
    end

    test 'gets meeting detail rows url is nil' do
      Processor::SaintPaul.get_meeting_detail_rows nil
    end

    test 'filters meeting detail rows' do
      m = @p.get_meeting_rows('City Council').first
      url = Processor::SaintPaul.extract_meeting_data(m)[:details]
      VCR.use_cassette('stp_legistar_details') do
        d = Processor::SaintPaul.get_meeting_detail_rows url, /^Resolution LH/

        assert_equal 5, d.count
      end
    end

    test 'filters meeting rows' do
      rows = @p.get_meeting_rows 'City Council'
      assert_equal 4, rows.count
    end

    test 'extract meeting data some nil' do
      rows = @p.get_meeting_rows 'City Council'
      d = Processor::SaintPaul.extract_meeting_data rows.first

      assert_equal 'City Council', d[:name]
      assert_equal '1/23/2019', d[:date]
      assert_equal "#{Processor::SaintPaul::URL}MeetingDetail.aspx?ID=673702&GUID=175B19CE-A034-4C76-B59D-EB264420F691&Options=info&Search=", d[:details]
      assert_equal "#{Processor::SaintPaul::URL}View.ashx?M=A&ID=673702&GUID=175B19CE-A034-4C76-B59D-EB264420F691", d[:agenda]
      assert_nil d[:minutes]
    end

    test 'extract meeting data none nil' do
      rows = @p.get_meeting_rows 'City Council'
      d = Processor::SaintPaul.extract_meeting_data rows[2]

      assert_equal 'City Council', d[:name]
      assert_equal '1/9/2019', d[:date]
      assert_equal "#{Processor::SaintPaul::URL}MeetingDetail.aspx?ID=670017&GUID=8FE16495-705F-4767-8C64-1A83376FB8F7&Options=info&Search=", d[:details]
      assert_equal "#{Processor::SaintPaul::URL}View.ashx?M=A&ID=670017&GUID=8FE16495-705F-4767-8C64-1A83376FB8F7", d[:agenda]
      assert_equal "#{Processor::SaintPaul::URL}View.ashx?M=M&ID=670017&GUID=8FE16495-705F-4767-8C64-1A83376FB8F7", d[:minutes]
    end

    test 'extract meeting detail data some nil' do
      m = @p.get_meeting_rows('City Council').first
      url = Processor::SaintPaul.extract_meeting_data(m)[:details]
      VCR.use_cassette('stp_legistar_details') do
        d = Processor::SaintPaul.get_meeting_detail_rows url, /^Resolution LH/
        r = Processor::SaintPaul.extract_meeting_detail_data(d.first)

        assert_equal 'RLH VO 18-61', r[:file_number]
        assert_equal 'https://stpaul.legistar.com/LegislationDetail.aspx?ID=3836184&GUID=0AAAB19D-37F8-4C62-8865-401A6412DBB8&Options=&Search=', r[:link]
        assert_equal '2', r[:version]
        assert_equal '602 Bush Ave.', r[:name]
        assert_equal 'Resolution LH Vacate Order', r[:item_type]
        assert_equal 'Appeal of Roberto Rodriguez to a Revocation of Fire Certificate of Occupancy and Order to Vacate at 602 BUSH AVENUE.', r[:title]
        assert       r[:action].blank?
        assert       r[:result].blank?
      end
    end

    test 'parse date string' do
      assert_equal Date.new(2019, 0o1, 30),
                   Processor::SaintPaul.send(:parse_date, '1/30/2019')
    end

    test 'persist meeting' do
      d = {
        name: 'City Council',
        date: '02/20/2019',
        details: 'https://www.example.com/test_deets',
        agenda: 'https://www.example.com/test_a',
        minutes: 'https://www.example.com/test_m'
      }
      Processor::SaintPaul.send(:persist_meeting, d)

      r = Meeting.last

      assert_equal d[:name], r.name
      assert_equal Date.new(2019, 0o2, 20), r.date
      assert_equal d[:details], r.details
      assert_equal d[:agenda], r.agenda
      assert_equal d[:minutes], r.minutes
    end

    # footer row we don't want to save
    test 'persist meeting -- errors' do
      ic = Meeting.count
      d = {
        name: "12\r\n\t\t\t\t\t\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t\t\t  Page 1 of 2, items 1 to 100 of 131.",
        date: '',
        details: '',
        agenda: '',
        minutes: ''
      }

      Processor::SaintPaul.send(:persist_meeting, d)

      assert_equal ic, Meeting.count
    end

    test 'update meeting when it exists' do
      mc = Meeting.count
      d = {
        name: 'City Council',
        date: '01/23/2019',
        details: 'https://wwww.example.com/updated_deets',
        agenda: 'https://www.example.com/agenda.1.23',
        minutes: 'https://www.example.com/minutes.1.23'
      }
      Processor::SaintPaul.send(:persist_meeting, d)

      assert_equal mc, Meeting.count

      r = Meeting.where(details: d[:details]).first

      assert_equal d[:name], r.name
      assert_equal Date.new(2019, 1, 23), r.date
      assert_equal d[:details], r.details
      assert_equal d[:agenda], r.agenda
      assert_equal d[:minutes], r.minutes
    end

    test 'persist item' do
      d = {
        name: 'City Council',
        date: '02/20/2019',
        details: 'https://www.example.com/test_deets',
        agenda: 'https://www.example.com/test_a',
        minutes: 'https://www.example.com/test_m'
      }

      Processor::SaintPaul.send(:persist_meeting, d)
      m = Meeting.last

      id = {
        file_number: 'RLH RR 01-02',
        link: 'http://goto.example',
        version: 2,
        name: '20002 Marshall Avenue Remove/Repair',
        item_type: 'Resolution LH Substantial Abatement Order',
        title: 'Ordering the rehabilitation or razing and removal of the structures at 20002 MARSHALL AVENUE within fifteen (15) days after the January 2, 2019, City Council Public Hearing. (Public hearing continued from January 2)',
        meeting: m
      }

      Processor::SaintPaul.send(:persist_item, id)

      r = Item.last

      assert_equal id[:file_number], r.file_number
      assert_equal id[:link], r.link
      assert_equal id[:version], r.version
      assert_equal id[:name], r.name
      assert_equal id[:item_type], r.item_type
      assert_equal id[:title], r.title
      assert_equal m.id, r.meeting.id
    end

    test 'update item when it exists' do
      ic = Item.count
      id = {
        file_number: 'RLH RR 01-02',
        link: 'http://goto.example',
        version: 2,
        name: '20002 Marshall Avenue Remove/Repair',
        item_type: 'Resolution LH Substantial Abatement Order',
        title: 'Ordering the rehabilitation or razing and removal of the structures at 20002 MARSHALL AVENUE within fifteen (15) days after the January 2, 2019, City Council Public Hearing. (Public hearing continued from January 2)',
        meeting_id: meetings(:meeting_two).id
      }

      Processor::SaintPaul.send(:persist_item, id)

      assert_equal ic, Item.count
      r = Item.where(file_number: 'RLH RR 01-02').first
      assert_equal id[:file_number], r.file_number
      assert_equal id[:link], r.link
      assert_equal id[:version], id[:version]
      assert_equal id[:name], r.name
      assert_equal id[:item_type], r.item_type
      assert_equal id[:title], r.title
      assert_equal id[:meeting_id], r.meeting.id
    end

    test 'add_geo_link with existing link' do
      h = {
        file_number: 'RLH RR 01-02',
        link: 'http://goto.example',
        version: 2,
        name: '20002 Marshall Avenue Remove/Repair',
        item_type: 'Resolution LH Substantial Abatement Order',
        title: 'Ordering the rehabilitation or razing and removal of the structures at 20002 MARSHALL AVENUE within fifteen (15) days after the January 2, 2019, City Council Public Hearing. (Public hearing continued from January 2)',
        meeting_id: meetings(:meeting_two).id,
        geo_link: 'https://blah'
      }

      i = Item.new h

      l = Processor::SaintPaul.send(:add_geo_link, i)

      assert_equal h[:geo_link], l
    end

    test 'add_geo_link without existing link' do
      VCR.use_cassette('mac') do
        h = {
          file_number: 'RLH RR 01-02',
          link: 'http://goto.example',
          version: 2,
          name: '1600 Grand Ave',
          item_type: 'Resolution LH Substantial Abatement Order',
          title: 'Ordering the rehabilitation or razing and removal of the structures...',
          meeting_id: meetings(:meeting_two).id
        }

        i = Item.new h

        l = Processor::SaintPaul.send(:add_geo_link, i)

        assert_equal 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=ChIJZW__ehcq9ocRYN-4nWCtgX4', l
      end
    end

    test 'urlify with nil href' do
      Row = Struct.new(:attributes)
      r = Row.new(k: 'val')

      assert_nil Processor::SaintPaul.send(:urlify, r)
    end

    test 'urlify with href' do
      TestRow = Struct.new(:attributes)
      Href = Struct.new(:text)
      h = Href.new('endpoint123')
      r = TestRow.new('href' => h)

      assert_equal 'https://stpaul.legistar.com/endpoint123', Processor::SaintPaul.send(:urlify, r)
    end

    test '#extract_meeting_detail_data no link child' do
      # Nokogiri::XML::Element
      row = <<~ROW
        <td nowrap><font face="Tahoma" size="2">
                                                                        <a id="ctl00_ContentPlaceHolder1_gridMain_ctl00_ctl04_hypFile"><font face="Tahoma" color="Blue" size="2">&nbsp;</font></a>
                                                                    </font></td>
        <td><font face="Tahoma" size="2">1</font></td>
        <td><font face="Tahoma" size="2">&nbsp;</font></td>
        <td><font face="Tahoma" size="2">&nbsp;</font></td>
        <td><font face="Tahoma" size="2">Resolution</font></td>
        <td><font face="Tahoma" size="2">Audit Workgroup</font></td>
        <td><font face="Tahoma" size="2">&nbsp;</font></td>
        <td><font face="Tahoma" size="2">&nbsp;</font></td>
        <td><font face="Tahoma" size="2">
                                                                        <a id="ctl00_ContentPlaceHolder1_gridMain_ctl00_ctl04_hypDetails" onclick="radopen('HistoryDetail.aspx?ID=20408559&amp;GUID=00837786-C814-4D04-A9DE-DB54D0D251EB', 'HistoryDetail');return false;" href="#"><font face="Tahoma" color="Blue" size="2">Action&nbsp;details</font></a>
                                                                    </font></td>
        <td><font face="Tahoma" size="2">
                                                                        <span style="white-space: nowrap;">


                                                                            <a id="ctl00_ContentPlaceHolder1_gridMain_ctl00_ctl04_hypVideo" class="historyVideoIndexNotAvailableLink"><font face="Tahoma" color="Gray" size="2">Not&nbsp;available</font></a>
                                                                        </span>
                                                                    </font></td>
      ROW

      nrow = Nokogiri::XML::Document.parse row
      Processor::SaintPaul.extract_meeting_detail_data nrow
    end
  end
end
