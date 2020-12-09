require 'rails_helper'

RSpec.describe User, type: :model do
  it { should define_enum_for(:role).with([:admin, :worker, :client]) }

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
end
