require_relative '../../../spec_helper'

describe Web::Controllers::Gijiroku::Update do
  describe 'when user is logged in' do
    let(:gijiroku) { Gijiroku.new(id: rand(1..50)) }
    let(:valid_params) {{
      id: gijiroku.id,
      gijiroku: {
        body: Faker::Lorem.paragraphs.join,
      },
    }}

    it 'is successful' do
      gijiroku_repo = MiniTest::Mock.new.expect(:find, gijiroku, [gijiroku.id])
                                        .expect(:update, nil, [gijiroku.id, valid_params[:gijiroku]])
      action =  Web::Controllers::Gijiroku::Update.new(
        gijiroku_repo: gijiroku_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(valid_params)

      _(response[0]).must_equal 302
      _(gijiroku_repo.verify).must_equal true
    end

    it 'is validation error' do
      gijiroku_repo = MiniTest::Mock.new.expect(:find, gijiroku, [gijiroku.id])
      action =  Web::Controllers::Gijiroku::Update.new(
        gijiroku_repo: gijiroku_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_params = {id: gijiroku.id, gijiroku: {body: nil}}
      response = action.call(invalid_params)

      _(response[0]).must_equal 200
      _(action.gijiroku).must_equal gijiroku
      _(gijiroku_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Gijiroku::Update.new(gijiroku_repo: nil, authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
