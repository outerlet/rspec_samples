require 'rails_helper'
require 'support/shared_contexts3'

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
        { title: 'xxxxx', author: 'aaaa', format: Book::FORMAT::POCKET, publisher: 'iiii' },
        { title: 'yyyyy', author: 'bbbb', format: Book::FORMAT::PAPERBACK, publisher: 'jjjj' }
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
