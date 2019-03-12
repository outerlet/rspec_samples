require 'rails_helper'

=begin
  let(:attribute) で宣言した属性の presence 制約を検証
  let(:type) に :nil か :empty のどちらで検証するか指定
  let(:expected) に期待する結果を true(=valid)/false(=invalid) で指定
=end
RSpec.shared_examples :presence_example do
  it :validate_presense do
    actual = build(factory, attribute => (type == :nil ? nil : ''))

    if expected
      expect(actual).to be_valid
    else
      expect(actual).to be_invalid
    end
  end
end

=begin
  let(:attribute) で宣言した属性の length 制約を検証
  let(:max_length) に、その属性が取りうる最大長を指定
=end
RSpec.shared_context :length_example do
  it :validate_length do
    expect(build(factory, attribute => 'a' * max_length)).to be_valid
    expect(build(factory, attribute => 'a' * (max_length + 1))).to be_invalid
  end
end

=begin
  let(:attribute) で宣言した属性の numericality(only_integer) 制約を検証
  let(:tester) に、その属性が取りうる値を「範囲」「配列」「単一の値」いずれかで指定
  let(:expected) には tester が配列か単一の値の場合に期待する結果を true(=valid)/false(=invalid) で指定
=end
RSpec.shared_examples :integer_example do
  it :validate_integer do
    # 範囲が与えられた場合は、その最大値および最小値が valid で、そこから外れた値が invalid であるかどうかテスト
    if tester.instance_of?(Range)
      expect(build(factory, attribute => tester.min)).to be_valid
      expect(build(factory, attribute => tester.max)).to be_valid
      expect(build(factory, attribute => tester.min - 1)).to be_invalid
      expect(build(factory, attribute => tester.max + 1)).to be_invalid
    # 配列で値が与えられた場合は、そこに含まれる全ての値が expected となるかどうかテスト
    elsif tester.instance_of?(Array)
      tester.each do |value|
        if expected
          expect(build(factory, attribute => value)).to be_valid
        else
          expect(build(factory, attribute => value)).to be_invalid
        end
      end
    # 単一の値が与えられた場合は、その値が expected であるかどうかテスト
    else
      if expected
        expect(build(factory, attribute => tester)).to be_valid
      else
        expect(build(factory, attribute => tester)).to be_invalid
      end
    end
  end
end

=begin
  let(:attribute) で宣言した属性の取りうる列挙値を検証
  const_enum gem で定義した列挙値を使用するフィールドが対象
  https://github.com/techscore/const_enum
  let(:enum) に、その属性の使用する列挙値を指定
=end
RSpec.shared_context :const_enum_example do
  it :validate_enum do
    # 列挙値の値を総当たりで確認
    enum.each do |e|
      expect(build(factory, attribute => e.value)).to be_valid
    end

    # 列挙値にない値を確認
    expect(build(factory, attribute => enum.values.min - 1)).to be_invalid
    expect(build(factory, attribute => enum.values.max + 1)).to be_invalid
  end
end

=begin
  レコードの重複を検証する
  let(:existance) と let(:tester) の属性は一致させること
  既存レコードの attribute に let(:existance) の値が設定されている状態で、以下の状況を順に検証する
  * 新規レコードの属性が全て既存レコードと同じ … 一意性制約に違反して invalid となる
  * 新規レコードの属性が1つずつ既存レコードの値と異なる … 一意性制約に違反せず valid となる
=end
RSpec.shared_context :uniqueness_example do
  it :validate_uniqueness do
    models = build_list(factory, existance.count + 2, existance)
    models[0].save!

    # 全てのフィールドが同じ場合は invalid となることを検証
    expect(models[1]).to be_invalid

    # tester で指定した属性の値が1つでも登録済みのレコードと異なれば valid となることを検証
    index = 2
    tester.each do |attr, value|
      model = models[index]
      model.write_attribute(attr, value)
      expect(model).to be_valid

      # 最近、色んな言語で後置インクリメントは歓迎されない傾向にある気がする…ので最後にインデックス増やす
      index += 1
    end
  end
end
