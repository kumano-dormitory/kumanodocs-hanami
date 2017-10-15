FactoryGirl.define do
  factory :meeting do
    transient do
      date_trans { Date.today + 30 }
    end

    date     { date_trans }
    deadline { (date_trans - 2).to_time }

    initialize_with { new(attributes) }
  end
end