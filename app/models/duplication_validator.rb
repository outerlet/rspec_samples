# 複数の属性で一意なレコードかどうかを検証
# uniqueness が既にあるけどユーザーに優しいメッセージを出すにはコードが冗長になりそうなので、
# 一意になるべき属性から日本語のメッセージを生成する検証クラスを自作
class DuplicationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    scopes = options[:scope]

    find_keys = { attribute => value }
    scopes.each do |other|
      find_keys[other] = record[other]
    end

    found = record.class.find_by(find_keys)
    if found.present? && record.id != found.id
      duplicated_names = scopes.map { |scope| record.class.human_attribute_name(scope) }.join('・')
      record.errors.add(attribute, I18n.t('errors.messages.duplicated', duplicated_names: duplicated_names))
    end
  end
end
