require 'rails_helper'

RSpec.describe Book, type: :model do
  # nilや空文字が入力された場合を検証するためのshared_context
  shared_context :presence_validation do
    let(:book) { build(:book, field => value) }

    context :nil do
      let(:value) { nil }
      it { is_expected.to be_invalid }
    end

    context :blank do
      let(:value) { nil }
      it { is_expected.to be_invalid }
    end

    context :present do
      let(:value) { 'あ' }
      it { is_expected.to be_valid }
    end
  end

  # 文字数の上限とそれを超えた値が入力された場合を検証するためのshared_context
  shared_context :length_validation do
    let(:book) { build(:book, field => value) }

    context :equal_max_length do
      let(:value) { 'あ' * max_length }
      it { is_expected.to be_valid }
    end

    context :over_max_length do
      let(:value) { 'あ' * (max_length + 1) }
      it { is_expected.to be_invalid }
    end
  end

  describe 'バリデーションの検証' do
    subject { book }

    # タイトルのバリデーションを検証
    context :title do
      let(:book) { build(:book, title: title) }

      describe :presence do
        context :nil do
          let(:title) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:title) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:title) { 'あ' }
          it { is_expected.to be_valid }
        end
      end

      describe :length do
        context :equal_max_length do
          let(:title) { 'あ' * 60 }
          it { is_expected.to be_valid }
        end
        
        context :over_max_length do
          let(:title) { 'あ' * 61 }
          it { is_expected.to be_invalid }
        end
      end

      # titleを含めた複数の属性で一意となるようにカスタムバリデーションを設定
      # 先に1つデータをDBに作成しておいて、全ての属性が同じオブジェクトを検証するとinvalidとなるか確認
      describe :duplication do
        let(:existance) { create(:book) }
        let(:book) { build(:book, title: title, author: author, format: format, publisher: publisher) }
        let(:title) { existance.title }
        let(:author) { existance.author }
        let(:format) { existance.format }
        let(:publisher) { existance.publisher }

        context :same_all do
          it { is_expected.to be_invalid }
        end

        describe :different do
          context :title do
            let(:title) { existance.title + '2' }
            it { is_expected.to be_valid }
          end

          context :author do
            let(:author) { existance.author + '2' }
            it { is_expected.to be_valid }
          end

          context :format do
            let(:format) { Book::FORMAT.select { |f| f.value != existance.format }.sample.value }
            it { is_expected.to be_valid }
          end

          context :publisher do
            let(:publisher) { existance.publisher + '2' }
            it { is_expected.to be_valid }
          end
        end
      end
    end
    
    # タイトル（カナ）のバリデーションを検証
    context :title_kana do
      let(:book) { build(:book, title_kana: title_kana) }

      describe :presence do
        context :nil do
          let(:title_kana) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:title_kana) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:title_kana) { 'ア' }
          it { is_expected.to be_valid }
        end
      end

      describe :length do
        context :length_equal do
          let(:title_kana) { 'あ' * 60 }
          it { is_expected.to be_valid }
        end
        
        context :length_too_long do
          let(:title_kana) { 'あ' * 61 }
          it { is_expected.to be_invalid }
        end
      end
    end
    
    # 筆者のバリデーションを検証
    context :author do
      let(:field) { :author }
      let(:max_length) { 30 }

      # shared_contextを利用
      include_context :presence_validation
      include_context :length_validation
    end
    
    context :format do
      let(:book) { build(:book, format: format) }

      describe :presence do
        context :nil do
          let(:format) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:format) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:format) { Book::FORMAT::POCKET }
          it { is_expected.to be_valid }
        end
      end

      describe :inclusion do
        context :valid_values do
          it {
            Book::FORMAT.each do |f|
              expect(build(:book, format: f.value)).to be_valid
            end
          }
        end

        context :invalid_values do
          it {
            [Book::FORMAT.values.min - 1, Book::FORMAT.values.max + 1].each do |f|
              expect(build(:book, format: f)).to be_invalid
            end
          }
        end
      end
    end
    
    # 価格のバリデーションを検証
    context :price do
      let(:book) { build(:book, price: price) }

      describe :presence do
        context :nil do
          let(:price) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:price) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:price) { 1000 }
          it { is_expected.to be_valid }
        end
      end

      describe :numericality do
        context :not_integer do
          let(:price) { 'a' }
          it { is_expected.to be_invalid }
        end

        context :invalid_integer do
          let(:price) { 99 }
          it { is_expected.to be_invalid }
        end

        context :valid_integer do
          let(:price) { 100 }
          it { is_expected.to be_valid }
        end
      end
    end
    
    # 出版社のバリデーションを検証
    context :publisher do
      let(:field) { :publisher }
      let(:max_length) { 60 }

      # shared_contextを利用
      include_context :presence_validation
      include_context :length_validation
    end
    
    # 出版年月のバリデーションを検証
    context :published do
      let(:book) { build(:book, published: published) }

      describe :presence do
        context :nil do
          let(:published) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:published) { '' }
          it { is_expected.to be_invalid }
        end
      end
    end
    
    # 概要のバリデーションを検証
    context :summary do
      let(:book) { build(:book, summary: summary) }

      describe :presence do
        context :nil do
          let(:summary) { nil }
          it { is_expected.to be_valid }
        end

        context :blank do
          let(:summary) { '' }
          it { is_expected.to be_valid }
        end

        context :present do
          let(:summary) { 'あ' }
          it { is_expected.to be_valid }
        end
      end

      describe :length do
        context :length_equal do
          let(:summary) { 'あ' * 100 }
          it { is_expected.to be_valid }
        end
        
        context :length_too_long do
          let(:summary) { 'あ' * 101 }
          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
