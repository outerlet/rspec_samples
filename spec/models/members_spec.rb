require 'rails_helper'
require 'support/shared_contexts2'
require 'support/shared_contexts3'

RSpec.describe Member, type: :model do
  let(:factory) { :member }

  describe 'バリデーションの検証' do
    context :name do
      let(:attribute) { :name }

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
        include_context :length_validation, 30
      end

      describe :duplication do
        context :try_example do
          let(:existance) { { name: '日本太郎', sex: Member::SEX::MALE, birthday: Date.today - 10.years } }
          let(:tester) { { name: '日本花子', sex: Member::SEX::FEMALE, birthday: Date.today - 11.years } }
          it_behaves_like :uniqueness_example
        end

        include_context :uniqueness_validation,
          { name: '日本太郎', sex: Member::SEX::MALE, birthday: Date.today - 10.years },
          { name: '日本花子', sex: Member::SEX::FEMALE, birthday: Date.today - 11.years }
      end
    end
    
    context :name_kana do
      let(:attribute) { :name_kana }

      describe :presence do
        include_context :presence_validation, :nil, false
        include_context :presence_validation, :empty, false
      end

      describe :length do
        context :try_example do
          let(:max_length) { 30 }
          it_behaves_like :length_example
        end
      end
    end
    
    context :sex do
      let(:attribute) { :sex }

      describe :presence do
        include_context :presence_validation, :nil, false
        include_context :presence_validation, :empty, false
      end

      describe :inclusion do
        context :try_example do
          let(:enum) { Member::SEX }
          it_behaves_like :const_enum_example
        end

        include_context :const_enum_validation, Member::SEX
      end
    end
    
    context :birthday do
      let(:attribute) { :birthday }

      describe :presence do
        include_context :presence_validation, :nil, false
        include_context :presence_validation, :empty, false
      end
    end
    
    context :prefecture_id do
      let(:attribute) { :prefecture_id }

      describe :presence do
        include_context :presence_validation, :nil, false
      end

      describe :reference do
        let(:ref_class) { Prefecture }
        it_behaves_like :reference_example
      end

      include_context :reference_validation, Prefecture
    end
    
    context :comment do
      let(:attribute) { :comment }

      describe :presence do
        include_context :presence_validation, :nil, true
        include_context :presence_validation, :empty, true
      end

      describe :equal_max_length do
        include_context :length_validation, 100
      end
    end
  end
end
