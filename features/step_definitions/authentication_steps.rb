Given /^I am signed in as a charity worker unrelated to "(.*?)" with password "(.*?)"$/ do |organization_name, password|
  #TODO: Not sure how to get devise session id to set
  #page.set_rack_session(:user_id => CharityWorker.find_by_admin(false).id)
  
end

Given /^I sign up as "(.*?)" with password "(.*?)" and password confirmation "(.*?)"$/ do |email, password,password_confirmation|
  fill_in "Email" , :with => email
  fill_in "user_password" , :with => password
  fill_in "user_password_confirmation" , :with => password_confirmation
  click_button "Sign up"
end

Given /^I sign in as a charity worker with permission to edit "(.*?)"$/ do |name|
  org = Organization.find_by_name name
  org.users   # TODO we will want some habtm to support this eventually
end

And /^I am signed in as the admin using password "(.*?)"$/ do |password|
  admin = User.find_by_admin(true)
  steps %Q{
    Given I am on the sign in page
    And I sign in as "#{admin.email}" with password "#{password}"
  }
end

And /^I am not signed in as the admin using password "(.*?)"$/ do |password|
  admin = User.find_by_admin(false)
  steps %Q{
    Given I am on the sign in page
    And I sign in as "#{admin.email}" with password "#{password}"
  }end

#TODO: Should we bypass mass assgiment in the creation via :without_protection?
Given /^the following users are registered:$/ do |users_table|
  users_table.hashes.each do |user|
    user["admin"] = user["admin"] == "true"
    user["organization"] = Organization.find_by_name(user["organization"])
    worker = User.create! user, :without_protection => true
  end
end

Given /^that I am logged in as any user$/ do
  steps %Q{
     Given the following users are registered:
   | email             | password |
   | jcodefx@gmail.com | pppppppp |
  } 
  steps %Q{
    Given I am on the sign in page
    And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  }
end

Then /^I should not be signed in as any user$/ do
  steps %Q{
    Given I am on the new charity page
    Then I should not see "Signed in as"
  }
end

When /^I sign out$/ do
  click_link 'Sign Out' 
end

Then /^I should be on the sign in page$/ do
  current_path.should == new_user_session_path
end

Given /^I sign in as "(.*?)" with password "(.*?)"$/ do |email, password|
  fill_in "Email" , :with => email
  fill_in "Password" , :with => password
  click_button "Sign in"
end

Given /^I am on the sign in page$/ do
  steps %Q{ 
    Given I am on the home page
  }
  click_link 'Org Login'
end

Given /^I am on the sign up page$/ do
  steps %Q{ 
    Given I am on the home page
  }
  click_link 'New Org?'
end
