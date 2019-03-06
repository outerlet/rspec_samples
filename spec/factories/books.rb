FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "題名_#{sprintf('%04d', n)}" }
    sequence(:title_kana) { |n| "タイトル_#{sprintf('%04d', n)}" }
    sequence(:author) { |n| "著者_#{sprintf('%04d', n)}" }
    format { Book::FORMAT.values.sample }
    sequence(:price) { |n| n * 100 }
    sequence(:publisher) { |n| "出版社_#{sprintf('%04d', n)}" }
    published { Date.today }
    sequence(:summary) { |n| "概要_#{sprintf('%04d', n)}" }

    trait :format_pocket do
      format { Book::FORMAT::POCKET }
    end

    trait :format_paperback do
      format { Book::FORMAT::PAPERBACK }
    end

    trait :format_hardcover do
      format { Book::FORMAT::HARDCOVER }
    end

    trait :format_comics do
      format { Book::FORMAT::COMICS }
    end
  end
end
