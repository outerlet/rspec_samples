json.extract! member, :id, :name, :name_kana, :sex, :birthday, :prefecture_id, :comment, :created_at, :updated_at
json.url member_url(member, format: :json)
