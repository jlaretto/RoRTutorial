# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }

    subject { @user }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:admin) }
    
    #test for relationship
    it { should respond_to(:relationships)}
    it { should respond_to(:followed_users)}
    it { should respond_to(:following?) }
    it { should respond_to(:follow!) }
    it { should respond_to(:unfollow!) }
    it { should respond_to(:followers)}    
     it { should respond_to(:microposts) }
      it { should respond_to(:feed) }
      
      
    it { should_not be_admin }
    describe "with admin attribute set to 'true'" do
        before { @user.toggle!(:admin) }

        it { should be_admin }
      end
  
  it { should respond_to(:remember_token) }
    it { should be_valid }
    it { should respond_to(:authenticate) }
    
    
    describe "when name is not present" do
      before { @user.name = " " }
      it { should_not be_valid }  
    end

    describe "when email format is invalid" do
      invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
      invalid_addresses.each do |invalid_address|
        before { @user.email = invalid_address }
        it { should_not be_valid }
      end
    end

    describe "when email format is valid" do
      valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
        before { @user.email = valid_address }
        it { should be_valid }
      end
    end
    
    describe "when email address is already taken" do
        before do
          user_with_same_email = @user.dup
          user_with_same_email.save
        end

        it { should_not be_valid }
    end

     describe "when password is not present" do
          before do
            @user.password = @user.password_confirmation = " "
          end
          it { should_not be_valid }
      end
      
      describe "when password does not match confirm" do
            before do
              @user.password = "foo"
              @user.password_confirmation = "bar"
            end
            it { should_not be_valid }
        end
        
        describe "when password confirmation is nil" do
          before { @user.password_confirmation = nil }
          it { should_not be_valid }
        end
      
      
      
      
        describe "return value of authenticate method" do
          before { @user.save }
          let(:found_user) { User.find_by_email(@user.email) }

          describe "with valid password" do
            it { should == found_user.authenticate(@user.password) }
          end
          
          describe "with invalid password" do
              let(:user_for_invalid_password) { found_user.authenticate("invalid") }

              it { should_not == user_for_invalid_password }
              specify { user_for_invalid_password.should be_false }
            end
          
        end 

        describe "with a passwords that too short" do
            before { @user.password = @user.password_confirmation = "a" * 5 }
            it { should be_invalid }
        end

        describe "remember token" do
          before { @user.save }
          its (:remember_token) {should_not be_blank}
        
        end
        describe "microposts tests ->" do
          before do
            @user.save
          end

           let!(:older_micropost) do 
               FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
             end
             let!(:newer_micropost) do
               FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
             end

             it "should have the right microposts in the right order" do
               @user.microposts.should == [newer_micropost, older_micropost]
             end  

             it "should destroy associated microposts" do
                   microposts = @user.microposts
                   @user.destroy
                   microposts.each do |micropost|
                     Micropost.find_by_id(micropost.id).should be_nil
                   end
                 end
                 
                 describe "status" do
                       let(:unfollowed_post) do
                         FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
                       end
                       let(:followed_user) { FactoryGirl.create(:user) }

                       before do
                         @user.follow!(followed_user)
                         3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
                       end

                       its(:feed) { should include(newer_micropost) }
                       its(:feed) { should include(older_micropost) }
                       its(:feed) { should_not include(unfollowed_post) }
                       its(:feed) do
                         followed_user.microposts.each do |micropost|
                           should include(micropost)
                         end
                       end
                end
                 
                   
      end  

      describe "following" do
          let(:other_user) {FactoryGirl.create(:user)}
          before do
            @user.save
            @user.follow!(other_user)
          end
          it { should be_following(other_user) }
          its(:followed_users) { should include(other_user) }
          
          describe "unfollowing after following" do
            before {@user.unfollow!(other_user)}
            it { should_not be_following(other_user) }
            its(:followed_users) { should_not include(other_user) }
            
          end
      end
      describe "followed" do
        let(:follower_user) {FactoryGirl.create(:user)}
        before do
          @user.save
          follower_user.save
          follower_user.follow!(@user)
        end
        its(:followers) {should include(follower_user)}
        
        describe "unfollowed" do
          before {follower_user.unfollow!(@user)}
          its(:followers) {should_not include(follower_user)}
        end
      end
end
