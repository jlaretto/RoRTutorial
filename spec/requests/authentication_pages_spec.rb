require 'spec_helper'

describe "Authentication" do
  subject {page}
  before {visit signin_path}
  
  describe "sign in page" do
    
    it { should have_selector('h1',    text: 'Sign in') }
        it { should have_selector('title', text: 'Sign in') }
  end
  
  describe "with invalid information" do
        before { click_button "Sign in" }

        it { should have_selector('title', text: 'Sign in') }
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
        describe "after visiting another page" do
          before { click_link "Home" }
          it { should_not have_selector('div.alert.alert-error') }
        end
      
      end
      describe "with valid information" do
            let(:user) { FactoryGirl.create(:user) }
            before do
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in" 
            end
            it { should have_selector('title', text: user.name) }
                 it { should have_link('Profile', href: user_path(user)) }
                       it { should have_link('Users',    href: users_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }                 
                 it { should have_link('Sign out', href: signout_path) }
                 it { should_not have_link('Sign in', href: signin_path) }
            end
            
            
            describe "authorization" do

                describe "for non-signed-in users" do
                  let(:user) { FactoryGirl.create(:user) }

                  describe "in the Users controller" do

                    describe "visiting the edit page" do
                      before { visit edit_user_path(user) }
                      it { should have_selector('title', text: 'Sign in') }
                    end

                    describe "submitting to the update action" do
                      before { put user_path(user) }
                      specify { response.should redirect_to(signin_path) }
                    end
                
                    describe "in the Microposts controller" do

                            describe "submitting to the create action" do
                              before { post microposts_path }
                              specify { response.should redirect_to(signin_path) }
                            end

                            describe "submitting to the destroy action" do
                              before do
                                micropost = FactoryGirl.create(:micropost)
                                delete micropost_path(micropost)
                              end
                              specify { response.should redirect_to(signin_path) }
                            end
                          end
                
                
                
                
                
                
                end
                  
                  
                  describe "as non-admin user" do
                    let(:user) { FactoryGirl.create(:user) }
                    let(:non_admin) { FactoryGirl.create(:user) }

                    before { sign_in non_admin }

                    describe "submitting a DELETE request to the Users#destroy action" do
                      before { delete user_path(user) }
                      specify { response.should redirect_to(users_path) }        
                    end
                  end
                  
                  
                end
      



 describe "friendly forward" do

      describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }


        describe "in the Relationships controller" do
               describe "submitting to the create action" do
                 before { post relationships_path }
                 specify { response.should redirect_to(signin_path) }
               end

               describe "submitting to the destroy action" do
                 before { delete relationship_path(1) }
                 specify { response.should redirect_to(signin_path) }          
               end
        end

        describe "visit protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email", with:user.email
            fill_in "Password", with:user.password
          click_button "Sign in"
          end

          describe "after signing in" do

                    it "should render the desired protected page" do
                      page.should have_selector('title', text: 'Edit user')
                    end
           end
    
      end
end end end 


  describe "visiting the user index" do
         before { visit users_path }
         it { should have_selector('title', text: 'Sign in') }
  end
end 

