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

        context :equal_max_length do
          let(:length) { 30 }
          it { is_expected.to be_valid }
        end

        context :over_max_length do
          let(:length) { 31 }
          it { is_expected.to be_invalid }
        end
      end

      describe :duplication do
        let(:existance) { create(:member) }
        let(:member) { build(:member, name: name, sex: sex, birthday: birthday) }
        let(:name) { existance.name }
        let(:sex) { existance.sex }
        let(:birthday) { existance.birthday }

        context :same_all do
          it { is_expected.to be_invalid }
        end

        describe :different do
          context :name do
            let(:name) { existance.name + '2' }
            it { is_expected.to be_valid }
          end

          context :sex do
            let(:sex) { Member::SEX.select { |s| s.value != existance.sex }.sample.value }
            it { is_expected.to be_valid }
          end

          context :birthday do
            let(:birthday) { existance.birthday + 1.day }
            it { is_expected.to be_valid }
          end
        end
      end
    end
    
    context :name_kana do
      let(:member) { build(:member, name_kana: name_kana) }

      describe :presence do
        context :nil do
          let(:name_kana) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:name_kana) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:name_kana) { 'ア' }
          it { is_expected.to be_valid }
        end
      end

      describe :length do
        context :length_equal do
          let(:name_kana) { 'あ' * 30 }
          it { is_expected.to be_valid }
        end
        
        context :length_too_long do
          let(:name_kana) { 'あ' * 31 }
          it { is_expected.to be_invalid }
        end
      end
    end
    
    context :sex do
      let(:member) { build(:member, sex: sex) }

      describe :presence do
        context :nil do
          let(:sex) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:sex) { '' }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:sex) { Member::SEX::MALE }
          it { is_expected.to be_valid }
        end
      end

      describe :inclusion do
        context :valid_values do
          it {
            Member::SEX.each do |s|
              expect(build(:member, sex: s.value)).to be_valid
            end
          }
        end

        context :invalid_values do
          it {
            [Member::SEX.values.min - 1, Member::SEX.values.max + 1].each do |s|
              expect(build(:member, sex: s)).to be_invalid
            end
          }
        end
      end
    end
    
    context :birthday do
      let(:member) { build(:member, birthday: birthday) }

      describe :presence do
        context :nil do
          let(:birthday) { nil }
          it { is_expected.to be_invalid }
        end

        context :blank do
          let(:birthday) { '' }
          it { is_expected.to be_invalid }
        end
      end
    end
    
    context :prefecture_id do
      let(:member) { build(:member, prefecture_id: prefecture_id) }

      describe :presence do
        context :nil do
          let(:prefecture_id) { nil }
          it { is_expected.to be_invalid }
        end

        context :present do
          let(:prefecture_id) { Prefecture.all.sample.id }
          it { is_expected.to be_valid }
        end
      end

      describe :valid_values do
        it {
          Prefecture.all.each do |pref|
            expect(build(:member, prefecture_id: pref.id)).to be_valid
          end
        }
      end

      describe :invalid_values do
        context :under_floor_id do
          let(:prefecture_id) { Prefecture.minimum(:id) - 1 }
          it { is_expected.to be_invalid }
        end

        context :over_ceil_id do
          let(:prefecture_id) { Prefecture.maximum(:id) + 1 }
          it { is_expected.to be_invalid }
        end
      end
    end
    
    context :comment do
      let(:member) { build(:member, comment: comment) }

      describe :presence do
        context :nil do
          let(:comment) { nil }
          it { is_expected.to be_valid }
        end

        context :blank do
          let(:comment) { '' }
          it { is_expected.to be_valid }
        end

        context :present do
          let(:comment) { 'あ' }
          it { is_expected.to be_valid }
        end
      end

      describe :equal_max_length do
        context :length_equal do
          let(:comment) { 'あ' * 100 }
          it { is_expected.to be_valid }
        end
        
        context :over_max_length do
          let(:comment) { 'あ' * 101 }
          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
