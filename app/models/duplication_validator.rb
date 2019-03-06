class DuplicationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    scopes = options[:scope]

    find_keys = { attribute => value }
    scopes.each do |other|
      find_keys[other] = record[other]
    end

    if record.class.find_by(find_keys).present?
      duplicated_names = scopes.map { |scope| record.class.human_attribute_name(scope) }.join('・')
      record.errors.add(attribute, I18n.t('errors.messages.duplicated', duplicated_names: duplicated_names))
    end
  end
end
