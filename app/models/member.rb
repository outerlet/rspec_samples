class Member < ApplicationRecord
  belongs_to :prefecture, optional: true
  
  const :SEX do
    MALE    1
    FEMALE  2
  end

  validates :name,
    presence: true,
    length: { maximum: 30 }
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

  validate :prefecture_valid?

  def age
    today = Date.today
    result = today.year - self.birthday.year
    result -= 1 if today.month < self.birthday.month || today.day < self.birthday.day
    result
  end

  private

  def prefecture_valid?
    errors.add(:prefecture_id, I18n.t('errors.messages.invalid_value')) if Prefecture.find_by(id: self.prefecture_id).blank?
  end
end
