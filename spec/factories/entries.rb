FactoryGirl.define do
  factory :entry do
    sequence(:name) {|n| "Entry No. #{n}" }
    sequence(:company_name) {|n| "Company #{n}" }
    sequence(:company_rfc) {|n| "CompanyRFC#{n}" }
    description 'This is my entry!'
    live_demo_url 'www.github.com/loqusea'
    association :member
    association :challenge

    trait :public do
      self.public true
    end
  end
end