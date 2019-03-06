class Book < ApplicationRecord
  const :FORMAT do
    POCKET    1
    PAPERBACK 2
    HARDCOVER 3
    COMICS    4
  end

  validates :title,
    presence: true,
    length: { maximum: 60 }
  validates :title_kana,
    presence: true,
    length: { maximum: 60 }
  validates :author,
    presence: true,
    length: { maximum: 30 }
  validates :format,
    presence: true,
    inclusion: { in: Book::FORMAT }
  validates :price,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 100, allow_blank: true }
  validates :publisher,
    presence: true,
    length: { maximum: 60 }
  validates :summary,
    presence: false,
    length: { maximum: 100 }
end
