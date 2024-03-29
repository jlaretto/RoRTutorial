require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong!
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to(:content) }


  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when user_id is not present" do
      before { @micropost.user_id = nil }
      it { should_not be_valid }
    end

    describe "with blank content" do
      before { @micropost.content = " " }
      it { should_not be_valid }
    end

    describe "with content that is too long" do
      before { @micropost.content = "a" * 141 }
      it { should_not be_valid }
    end
    
  describe "from users followed by" do
  
    let(:main_user) {FactoryGirl.create(:user)}
    let(:second_user) {FactoryGirl.create(:user)}
    let(:third_user) {FactoryGirl.create(:user)}
    
    before {main_user.follow!(third_user)}
    
    let(:user_post) { main_user.microposts.create!(content: "My post")}
    let(:second_post) { second_user.microposts.create!(content: "SEcond guy post")}
    let(:third_post) { third_user.microposts.create!(content: "Third guy post")}
    
    subject { Micropost.from_users_followed_by(main_user) }
    
    it{ should include(user_post)}
    it{ should_not include(second_post)}
    it{ should include(third_post)}
    
  end

end