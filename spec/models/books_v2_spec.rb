require 'rails_helper'
require 'support/shared_contexts2'

RSpec.describe Book, type: :model do
  describe 'バリデーションの検証' do
    let(:factory) { :book }

    # タイトルのバリデーションを検証
    context :title do
      let(:attribute) { :title }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end

      describe :length do
        let(:max_length) { 60 }
        it_behaves_like :length_example
      end

      describe :uniqueness do
        let(:existance) { { title: 'xxxxx', author: 'aaaa', format: Book::FORMAT::POCKET, publisher: 'iiii' } }
        let(:tester) { { title: 'yyyyy', author: 'bbbb', format: Book::FORMAT::PAPERBACK, publisher: 'jjjj' } }
        it_behaves_like :uniqueness_example
      end
    end
    
    # タイトル（カナ）のバリデーションを検証
    context :title_kana do
      let(:attribute) { :title_kana }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end

      describe :length do
        context :max_length do
          let(:max_length) { 60 }
          it_behaves_like :length_example
        end
      end
    end
    
    # 筆者のバリデーションを検証
    context :author do
      let(:attribute) { :author }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end

      describe :length do
        context :max_length do
          let(:max_length) { 30 }
          it_behaves_like :length_example
        end
      end
    end
    
    context :format do
      let(:attribute) { :format }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end

      describe :enum do
        context :enum do
          let(:enum) { Book::FORMAT }
          it_behaves_like :const_enum_example
        end
      end
    end
    
    # 価格のバリデーションを検証
    context :price do
      let(:attribute) { :price }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end

      describe :numericality do
        context :invalid do
          let(:tester) { [ 99, 'aaa' ] }
          let(:expected) { false }
          it_behaves_like :integer_example
        end

        context :valid do
          let(:tester) { 100 }
          let(:expected) { true }
          it_behaves_like :integer_example
        end
      end
    end
    
    # 出版社のバリデーションを検証
    context :publisher do
      let(:attribute) { :publisher }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end

      describe :length do
        context :max_length do
          let(:max_length) { 60 }
          it_behaves_like :length_example
        end
      end
    end
    
    # 出版年月のバリデーションを検証
    context :published do
      let(:attribute) { :published }

      describe :presence do
        let(:expected) { false }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end
      end
    end
    
    # 概要のバリデーションを検証
    context :summary do
      let(:attribute) { :summary }

      describe :presence do
        let(:expected) { true }

        context :nil do
          let(:type) { :nil }
          it_behaves_like :presence_example
        end

        context :empty do
          let(:type) { :empty }
          it_behaves_like :presence_example
        end

        describe :length do
          context :max_length do
            let(:max_length) { 100 }
            it_behaves_like :length_example
          end
        end
      end
    end
  end
end
