FactoryBot.define do
  factory :member do
    sequence(:name) { |n| "氏名_#{sprintf('%04d', n)}" }
    sequence(:name_kana) { |n| "シメイ_#{sprintf('%04d', n)}" }
    sex { Member::SEX::MALE }
    sequence(:birthday) { |n| Date.today - n.years }
    prefecture_id { Prefecture.all.sample.id }
    sequence(:comment) { |n| "コメント_#{sprintf('%08d', n)}" }
    
    trait :sex_male do
      sequence(:name) { |n| "#{n.to_s}代目 日本太郎" }
      sequence(:name_kana) { |n| "#{n.to_s}ダイメ ニホンタロウ" }
      sex { Member::SEX::MALE }
    end

    trait :sex_female do
      sequence(:name) { |n| "#{n.to_s}代目 日本花子" }
      sequence(:name_kana) { |n| "#{n.to_s}ダイメ ニホンハナコ" }
      sex { Member::SEX::FEMALE }
    end
  end
end
