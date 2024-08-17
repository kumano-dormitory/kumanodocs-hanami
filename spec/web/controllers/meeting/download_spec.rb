require_relative '../../../spec_helper'

describe Web::Controllers::Meeting::Download do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..50), date: (Date.today)) }
    let(:meetings) { [meeting] }
    let(:interactor_result) { Minitest::Mock.new.expect(:failure?, false).expect(:path, path)}
    let(:path) { '/tmp/hogehoge' }
    let(:params) { {id: meeting.id} }

    it 'is successful download meeting' do
      specification = Specifications::Pdf.new(type: :web_articles, meeting_id: meeting.id)
      generate_pdf = Minitest::Mock.new.expect(:call, interactor_result, [specification])
      action = Web::Controllers::Meeting::Download.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [meeting.id]),
        generate_pdf_interactor: generate_pdf,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params)

      _(response[0]).must_equal 404
      _(response[1]['Content-Disposition']).must_match "#{meeting.date}"
      _(generate_pdf.verify).must_equal true
      _(interactor_result.verify).must_equal true
    end

    it 'is successful display select meeting page' do
      meeting_repo = Minitest::Mock.new.expect(:desc_by_date, meetings, [Hash])
      action = Web::Controllers::Meeting::Download.new(
        meeting_repo: meeting_repo, generate_pdf_interactor: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call({})

      _(response[0]).must_equal 200
      _(action.meetings).must_equal meetings
      _(meeting_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Meeting::Download.new(
        meeting_repo: nil, generate_pdf_interactor: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
