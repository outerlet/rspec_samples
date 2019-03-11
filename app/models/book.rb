class Book < ApplicationRecord
  const :FORMAT do
    POCKET    1   # 文庫
    PAPERBACK 2   # 新書
    HARDCOVER 3   # ハードカバー
    COMICS    4   # コミック
  end

  # 一意性の検証には独自クラスを使用
  validates :title,
    presence: true,
    length: { maximum: 60 },
    duplication: { scope: %i(author format publisher) }
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
  validates :published,
    presence: true
  validates :summary,
    presence: false,
    length: { maximum: 100 }
end
