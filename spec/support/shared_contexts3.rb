require 'rails_helper'

=begin
  let(:attribute) で宣言した属性の presence 制約を検証
  include_context の第1引数に :nil か :empty のどちらで検証するか指定
  第2引数に期待する結果を true(=valid)/false(=invalid) で指定
=end
RSpec.shared_context :presence_validation do |type, expected|
  let(:actual) { build(factory, attribute => value) }

  context (type == :nil ? 'nil' : 'empty') do
    let(:value) { type == :nil ? nil : '' }
    it { expect(actual).to (expected ? be_valid : be_invalid) }
  end
end

=begin
  let(:attribute) で宣言した属性の length 制約を検証
  include_context の第1引数に、その属性が取りうる最大長を指定
=end
RSpec.shared_context :length_validation do |max_length|
  let(:actual) { build(factory, attribute => value) }

  [max_length, max_length + 1].each do |length|
    context length == max_length ? 'equals' : 'too-long' do
      let(:value) { 'a' * length }

      if length == max_length
        it { expect(actual).to be_valid }
      else
        it { expect(actual).to be_invalid }
      end
    end
  end
end

=begin
  let(:attribute) で宣言した属性の numericality(only_integer) 制約を検証
  include_context の第1引数に、その属性が取りうる値を「範囲」「配列」「単一の値」いずれかで指定
  第2引数には、配列か単一の値を指定した場合に期待する結果を true(=valid)/false(=invalid) で指定
=end
RSpec.shared_context :integer_validation do |tester, expected|
  let(:actual) { build(factory, attribute => value) }

  # 範囲が与えられた場合は、その最大値および最小値が valid で、そこから外れた値が invalid であるかどうかテスト
  if tester.instance_of?(Range)
    [ tester.min, tester.max ].each do |v|
      context v.to_s do
        let(:value) { v }
        it { expect(actual).to be_valid }
      end
    end

    [ tester.min - 1, tester.max + 1 ].each do |v|
      context v.to_s do
        let(:value) { v }
        it { expect(actual).to be_invalid }
      end
    end
  # 配列で値が与えられた場合は、そこに含まれる全ての値が expected となるかどうかテスト
  elsif tester.instance_of?(Array)
    tester.each do |v|
      context v.to_s do
        let(:value) { v }

        if expected
          it { expect(actual).to be_valid }
        else
          it { expect(actual).to be_invalid }
        end
      end
    end
  # 単一の値が与えられた場合は、その値だけが valid であるかどうかテスト
  else
    context tester.to_s do
      let(:value) { tester }
      if expected
        it { expect(actual).to be_valid }
      else
        it { expect(actual).to be_invalid }
      end
    end
  end
end

=begin
  let(:attribute) で宣言した属性の取りうる列挙値を検証
  const_enum gem で定義した列挙値を使用する属性が対象
  https://github.com/techscore/const_enum
  include_context の第1引数に、その属性の使用する列挙値を指定
=end
RSpec.shared_context :const_enum_validation do |enum|
  let(:actual) { build(factory, attribute => value) }

  # 列挙値の値を総当たりで確認
  enum.each do |e|
    context e.key.to_s do
      let(:value) { e.value }
      it { expect(actual).to be_valid }
    end
  end

  # 列挙値にない値を確認
  [enum.values.min - 1, enum.values.max + 1].each do |e|
    context e.to_s do
      let(:value) { e }
      it { expect(actual).to be_invalid }
    end
  end
end

=begin
  レコードの重複を検証する
  existance と tester の属性は一致させること
  既存レコードの attribute に existance の値が設定されている状態で、以下の状況を順に検証する
  * 新規レコードの属性が全て既存レコードと同じ … 一意性制約に違反して invalid となる
  * 新規レコードの属性が1つずつ既存レコードの値と異なる … 一意性制約に違反せず valid となる
=end
RSpec.shared_context :uniqueness_validation do |existance, tester|
  let(:models) {
    models = build_list(factory, 2, existance)
    models.first.save!
    models
  }

  # 全ての属性が同じ場合は invalid となることを検証
  context :duplicated do
    it { expect(models.last).to be_invalid }
  end

  # tester で指定した属性の値が1つでも登録済みのレコードと異なれば valid となることを検証
  tester.each do |attr, value|
    context "#{attr.to_s} = #{value}" do
      it {
        models.last.write_attribute(attr, value)
        expect(models.last).to be_valid
      }
    end
  end
end

=begin
  アソシエーションのある属性を検証する
  第1引数には当該属性が参照するモデルクラスを与える
  そのモデルにある id 値をセットして全て valid となり、無い id 値をセットして invalid にあることを検証
=end
RSpec.shared_context :reference_validation do |ref_class|
  let(:actual) { build(factory, attribute => model_id) }

  ref_class.all.map { |m| m.id }.each do |model_id|
    context model_id.to_s do
      let(:model_id) { model_id }
      it { expect(actual).to be_valid }
    end
  end

  [ ref_class.minimum(:id) - 1, ref_class.maximum(:id) + 1 ].each do |model_id|
    context model_id.to_s do
      let(:model_id) { model_id }
      it { expect(actual).to be_invalid }
    end
  end
end
