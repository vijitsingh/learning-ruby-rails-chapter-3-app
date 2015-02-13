

-- Add edit form
- Create a user_controller.rb # edit method with @user = User.find(params[:id])
- Create a edit.html.erb with almost same content as the new.html.erb except added stuff for gravatar
- # NOTE here the presence of this in form : <input name="_method" type="hidden" value="patch" />
- In settings link, add : <%= link_to "Settings", edit_user_path(current_user) %> . 

-- Handle unsuccessful edits
- Add a update method in user_controller.rb
- Add if @user.update_attributes(sanitize_user_params)
- render 'edit' in else. This is similar to the create method format
- Try submitting with incomplete parameters, and you could see the errors are shown because of the error_messages partial added. 

-- Testing unsuccessful edits
- rails generate integration_test users_edit
- Add a test case to verify that if incorrect parameters are submitted then again the users/edit template is rendered. 
- run rake test:integration which should pass. 

-- Successful edits handling
- In the if case of update method, add flash message and redirect_to @user similar to create method. 
- Add a test case to verify that flash message is non-empty on successful login, redirection happens to @user, and after @user.reload, parameters updage. 
- at this point of time test would fail because of empty password in the test # if user does NOT want to update password each time
- Add allow_blank : true with :password field in the user_model . # this would not allow blank password on account creation, as has_secure_password takes care of that. 
- now tests would pass. 

-- Adding conditions to make sure user is logged-in before allowing edit or update
- Add a new method logged_in_user which checks whether logged_in? and sets flash message and redirects to login_url if false.
- add a condtion "before_action :logged_in_user, only: [:edit, :update]" in the controller
- At this point user_edit integration tests should fail. So now in both the methods call the helper method log_in_as(@user)
- Now tests shoud pass. but you want them to fail if not-logged-in. So add tests to verify the above added behavior
- Add test in user_controller_test.rb to verify that redirect happens and flash message is set when tried to access the edit or update actions without login. 

-- Addition condition to check that the logged in person could edit/update his profile only
- Add "before_action :correct_user, only: [:edit, :update]"
- correct_user checks that logged in user is same as the user being tried to access, else redirects to root-url
- Add a new fixture and in setup for user_controller_test.rb, create @other_user
- Add 2 test cases, where you log_in_as(@other_user) and then tries to access edit/update page for @user, in both these cases verify that redirection to root_url happens. 

-- Add friendly forwarding : to retain the url which you were trying to access before required to login
- in sessions_helper.rb, add method store_location which stores session[:forwarding_url] = request.url if request.get?
- in sessions_helper.rb, add method redirect_back_or(default) that either redirects to forwarding_url if present in session else to default
- call store_location from logged_in_user method in users_controller.rb
- call redirect_back_or(user) from create method of session-controller
- modify test in user_edit_test.rb and change to : successful edit with friendly forwarding to test this functionality as well. 

-- Add Users index page
- Add a test-case in users-controller to redirect if not logged in and trying to access the index page. 
- Add :index in the before_action list for :logged_in_user in user-controller
- Add index action with @users = User.all
- Add a index.html.erb to iterate over all users and show. Also add corresponding css.
- Update the link in _header partial for Users to use users_path. 

-- Adding Sample users and how to use db:seed to initialize the database
- Add a faker gem in Gemfile and install.
- in db/seeds.rb : add sample users by iterating, uses name = Faker::Name.name
- bundle exec rake db:seed 
- Shows a lot of users on the user page now. 

-- Add pagination support for index users : https://www.railstutorial.org/book/updating_and_deleting_users#sec-pagination
- Add gems will_paginate and bootstrap_will_paginate and install them
- Add <%= will_paginate %> in top and bottom of the index.html.erb
- add @users = User.paginate(page: params[:page]) in index method of user-controller. 
- restart server and pagination works. 

-- Add Users index test : https://www.railstutorial.org/book/updating_and_deleting_users#sec-users_index_test
- Update users.yml fixture to add 30 dummy users using Faker::Name.name
- rails generate integration_test users_index
- add the test case "index including pagination" where you check that div.pagination is present, and divs corresponding to each user is present. Worth noting, how it tries User.paginate(page: 1) to figure out what all users would be shown and then checks for divs for them. 

-- Partial refactoring : https://www.railstutorial.org/book/updating_and_deleting_users#sec-partial_refactoring 
- I decided to skip since NOT make much sense 

-- Add an admin attribute in user : https://www.railstutorial.org/book/updating_and_deleting_users#sec-administrative_users
- rails generate migration add_admin_to_users admin:boolean
- Add default: false in the generated above
- run bundle exec rake db:migrate
- I gave admin permissions to myself by loading User.frist in rails console, modifying the param and then user.save. Could have done by adding value in the generated list of users in db/seeds.rb
- Automatically adds a method admin? because of boolean nature of the param. 
- Note the presence of strong params (sanitize_params) allows here that no one is able to override admin attribute from web directly. 

-- Adding the destroy action : https://www.railstutorial.org/book/updating_and_deleting_users#sec-the_destroy_action
- Add <% if current_user.admin? && !current_user?(user) %> | <%= link_to "delete", user, method: :delete, data: { confirm: "You sure?" } %> <% end %> in index.html.erb
- Add a destroy method in controller which User.find(params[:id]).delete, then updates flash message and redirect to users_url
- Add before_action :admin_user, only: [:destroy] to make sure only admin users can issue this request. 
- Also add :destroy in list for :logged_in_user
- Add admin_user method above. 

-- User destroy tests : https://www.railstutorial.org/book/updating_and_deleting_users#sec-user_destroy_tests
- Decided to skip. 

DONE. 
