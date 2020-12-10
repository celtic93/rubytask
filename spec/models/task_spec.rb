require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:worker).class_name('User').optional(:true) }

  it { should validate_presence_of :body }
end
