require 'spec_helper'

describe "UserPages" do
  subject {page}
  
  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "user profile page" do
    let(:user) {FactoryGirl.create(:user)}
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  
  
        let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
        let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

        before { visit user_path(user) }

        it { should have_selector('h1',    text: user.name) }
        it { should have_selector('title', text: user.name) }

        describe "microposts" do
          it { should have_content(m1.content) }
          it { should have_content(m2.content) }
          it { should have_content(user.microposts.count) }
      end
  
      describe "status" do
            let(:unfollowed_post) do
              FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
            end

            its(:feed) { should include(newer_micropost) }
            its(:feed) { should include(older_micropost) }
            its(:feed) { should_not include(unfollowed_post) }
          end
  end

  describe "signup" do

      before { visit signup_path }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button "Create my account" }.not_to change(User, :count)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        it "should create a user" do
          expect do
            click_button "Create my account"
          end.to change(User, :count).by(1)
        end
      end
    end
    describe "edit" do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in user
          visit edit_user_path(user) 
        end

        describe "page" do
          it { should have_selector('h1',    text: "Update your profile") }
          it { should have_selector('title', text: "Edit user") }
          it { should have_link('change', href: 'http://gravatar.com/emails') }
        end

        describe "with invalid information" do
          before { click_button "Save changes" }

          it { should have_content('error') }
        end
        describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
      end
      
      
      
    

         describe "Pagination" do

            before(:all) { 30.times { FactoryGirl.create(:user) } }
            after(:all)  { User.delete_all }
            let(:user) {FactoryGirl.create(:user)}
            let(:admin) {FactoryGirl.create(:admin)}

            before do 
              sign_in user
              visit users_path 
            end

            it { should have_link('Next') }
                  its(:html) { should match('>2</a>') }

                  it "should list each user" do
                    User.all[0..3].each do |usr|
                      page.should have_selector('li', text: usr.name)
                    end
                  end

            it {should_not have_link('delete')}

            describe "with admin logged in" do
              before do
                sign_in admin
                visit users_path
              end
              it { should have_link('delete', href: user_path(User.first)) }

              it "should be able to delete another user" do
                expect { click_link('delete') }.to change(User, :count).by(-1)
              end
              it { should_not have_link('delete', href: user_path(admin)) }

            end
            

        end
      
      
      
end
