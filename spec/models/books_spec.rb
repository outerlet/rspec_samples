require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'バリデーションの検証' do
    subject { book }

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
        context :length_equal do
          let(:title) { 'あ' * 60 }
          it { is_expected.to be_valid }
        end
        
        context :length_too_long do
          let(:title) { 'あ' * 61 }
          it { is_expected.to be_invalid }
        end
      end

      describe :duplication do
      end
    end
    
    context :title_kana do
    end
    
    context :author do
    end
    
    context :format do
    end
    
    context :price do
    end
    
    context :publisher do
    end
    
    context :published do
    end
    
    context :summary do
    end
  end
end
