class Member < ApplicationRecord
  belongs_to :prefecture, optional: true
  
  const :SEX do
    MALE    1
    FEMALE  2
  end

  validates :name,
    presence: true,
    length: { maximum: 30 },
    uniqueness: {
      scope: %i(sex birthday),
      attribute_names: %i(sex birthday).map { |attr| Member.human_attribute_name(attr) }.join('・')
    }
  validates :name_kana,
    presence: true,
    length: { maximum: 30 }
  validates :sex,
    presence: true,
    inclusion: { in: SEX }
  validates :birthday,
    presence: true
  validates :comment,
    presence: false,
    length: { maximum: 100, allow_blank: true }
  validates :prefecture_id,
    prefecture: true

  def age
    today = Date.today
    result = today.year - self.birthday.year
    result -= 1 if today.month < self.birthday.month || today.day < self.birthday.day
    result
  end
end
