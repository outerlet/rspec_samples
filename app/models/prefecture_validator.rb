class PrefectureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if Prefecture.find_by(id: value).blank?
      record.errors.add(attribute, I18n.t('errors.messages.invalid'))
    end
  end
end
