require 'rails_helper'
require 'support/shared_contexts'

RSpec.describe Book, type: :model do
  describe 'バリデーションの検証' do
    let(:factory) { :book }

    # タイトルのバリデーションを検証
    context :title do
      let(:attribute) { :title }

      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
      include_context :length_validation, 60

      include_context :uniqueness_validation,
        title: ['xxxxx', 'yyyyy'],
        author: ['aaaa', 'bbbb'],
        format: [Book::FORMAT::POCKET, Book::FORMAT::PAPERBACK],
        publisher: ['iiii', 'jjjj']

=begin
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
=end
    end
    
    # タイトル（カナ）のバリデーションを検証
    context :title_kana do
      let(:attribute) { :title_kana }
      
      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
      include_context :length_validation, 60
    end
    
    # 筆者のバリデーションを検証
    context :author do
      let(:attribute) { :author }

      # shared_contextを利用
      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
      include_context :length_validation, 30
    end
    
    # フォーマットのバリデーションを検証
    context :format do
      let(:attribute) { :format }

      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
      include_context :const_enum_validation, Book::FORMAT
    end
    
    # 価格のバリデーションを検証
    context :price do
      let(:attribute) { :price }

      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
      include_context :integer_validation, [ 99, 'aaa' ], false
      include_context :integer_validation, 100, true
    end
    
    # 出版社のバリデーションを検証
    context :publisher do
      let(:attribute) { :publisher }

      # shared_contextを利用
      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
      include_context :length_validation, 60
    end
    
    # 出版年月のバリデーションを検証
    context :published do
      let(:attribute) { :published }

      include_context :presence_validation, :nil, false
      include_context :presence_validation, :empty, false
    end
    
    # 概要のバリデーションを検証
    context :summary do
      let(:attribute) { :summary }

      include_context :presence_validation, :nil, true
      include_context :presence_validation, :empty, true
      include_context :length_validation, 100
    end
  end
end
