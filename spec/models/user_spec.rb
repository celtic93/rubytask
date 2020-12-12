require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many :tasks }
  it { should have_many(:work_tasks).class_name('Task') }

  it { should define_enum_for(:role).with_values([:admin, :worker, :client]) }

  it { should validate_presence_of :login }
  it { should validate_presence_of :fullname }
  it { should validate_presence_of :birthday }
  it { should validate_presence_of :email }
  it { should validate_presence_of :address }
  it { should validate_presence_of :city }
  it { should validate_presence_of :state }
  it { should validate_presence_of :country }
  it { should validate_presence_of :zip }
  it { should validate_presence_of :password }
  it { should validate_presence_of :role }

  let(:users) { create_list(:user, 2, :client) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }
  let(:task) { create(:task, user: user) }

  describe '.author?' do
    it 'verifies the authorship of the resource' do
      expect(user).to be_author(task)
      expect(other_user).to_not be_author(task)
    end
  end
end
