require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:task) }

  it { should validate_presence_of :body }
  it { should validate_content_type_of(:image).allowing('image/png', 'image/jpg', 'image/jpeg') }
  it { should validate_size_of(:image).less_than(1.megabyte) }

  it 'has one attached image' do
    expect(Comment.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
