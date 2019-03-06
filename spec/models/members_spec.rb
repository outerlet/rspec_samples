require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { member }

  describe 'バリデーションの検証' do
    context :name do
      let(:member) { build(:member, name: name) }

      describe :presence do
        context :nil do
          let(:name) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:name) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:name) { 'あ' }
          it { is_expected.to be_valid }
        end
      end

      describe :length do
        let(:name) { 'あ' * length }
        
        context :equal_maximum do
          let(:length) { 30 }
          it { is_expected.to be_valid }
        end

        context :over_maximum do
          let(:length) { 31 }
          it { is_expected.to be_invalid }
        end
      end
    end
    
    context :name_kana do
    end
    
    context :sex do
    end
    
    context :birthday do
    end
    
    context :prefecture_id do
    end
    
    context :comment do
    end
  end
end
