require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/edit'

describe Admin::Controllers::Meeting::Download do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..50), date: (Date.today + 30)) }
    let(:path) { "/tmp/hogehoge" }
    let(:params) { { id: meeting.id } }
    let(:params_for_articles) { {id: meeting.id, articles: true} }
    let(:params_for_comments) { {id: meeting.id, comments: true} }

    it 'is successful for select meeting' do
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: Minitest::Mock.new.expect(:desc_by_date, [meeting], [Hash]),
        generate_pdf_interactor: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call({})
      _(response[0]).must_equal 200
      _(action.meetings).must_equal [meeting]
      _(action.view_type).must_equal :meetings
    end

    it 'is successful for select download type' do
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [meeting.id]),
        generate_pdf_interactor: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.meeting).must_equal meeting
      _(action.view_type).must_equal :meeting
    end

    it 'is successful for download articles pdf' do
      interactor_result = Minitest::Mock.new.expect(:failure?, false).expect(:path, path)
      specification = Specifications::Pdf.new(type: :admin_articles, meeting_id: meeting.id, after_6pm: false)
      generate_pdf = Minitest::Mock.new.expect(:call, interactor_result, [specification])
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [meeting.id]),
        generate_pdf_interactor: generate_pdf,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params_for_articles)

      _(response[0]).must_equal 404
      _(response[1]['Content-Disposition']).must_match "#{meeting.date}"
      _(action.format).must_equal :pdf
      _(generate_pdf.verify).must_equal true
      _(interactor_result.verify).must_equal true
    end

    it 'is successful for download comments pdf' do
      interactor_result = Minitest::Mock.new.expect(:failure?, false).expect(:path, path)
      specification = Specifications::Pdf.new(type: :admin_comments, meeting_id: meeting.id)
      generate_pdf = Minitest::Mock.new.expect(:call, interactor_result, [specification])
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: Minitest::Mock.new.expect(:find, meeting, [meeting.id]),
        generate_pdf_interactor: generate_pdf,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params_for_comments)

      _(response[0]).must_equal 404
      _(response[1]['Content-Disposition']).must_match "#{meeting.date}"
      _(action.format).must_equal :pdf
      _(generate_pdf.verify).must_equal true
      _(interactor_result.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Download.new(
        meeting_repo: nil, generate_pdf_interactor: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
