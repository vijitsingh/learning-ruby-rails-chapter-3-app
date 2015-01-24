
Commands ran to build this application : 

- Setup the project
- Update Gemfile
- Add to git
- bundle update # to update dependencies to their latest version, need to investigate more on what this does. 
- make hello world changes
- update to heroku

- heroku logs # NEW_COMMAND. to check heroku logs 

-- Generate StaticPages controller
- git checkout -b static-pages
- rails generate controller StaticPages home help
- push to git
- rails server # to open localhost:3000/static_pages/home works 

-- Box 3.1 : Commands to undo / rollback in rails (NOT USED ANY OF THEM HERE)
- rails generate controller StaticPages home help
- rails destroy controller StaticPages home help
- rails generate model User name:string email:string
- rails destroy model User
- bundle exec rake db:migrate 
- bundle exec rake db:rollback
- OR bundle exec rake db:migrate VERSION=0 #to rollback to beginning. Version_no determines which version to rollback to

-- Running Tests and Adding About page using TDD approach
- bundle exec rake test
- Add test for about page in test/controllers/static_pages_controller_test.rb and run rake test again to fail. 
- Add route in routes.rb and then run rake test again
- add empty action in the controller and run test again
- add app/views/static_pages/about.html.erb and run test again which should pass now. 

-- Adding Title to each of the three pages.
- mv app/views/layouts/application.html.erb layout_file # temp change to understand the utility of layout
- add assert_select "title", "Home | Ruby Book" For each of the actions in the test file 
- now tests should fail. 
- add title to the pages in the app/views/static_pages/*.html.erb ones. 
- run tests again and now they should pass. 

-- Using Embedded Ruby and layout to make pages dynamic in nature.
- use provide and yield to add title and make the formats for the 3 .html.erb files same. 
- run the tests to make sure they pass
- mv layout_file app/views/layouts/application.html.erb
- <title><%= yield(:title) %> | Rails Book</title> in the layout file. 
- leave only the content part in the each of the 3 pages and then run test again. 

-- Setting the Root Route
- replace get with root 'static_pages#home'

-- Finish the app
- Push code to github (merge branch to master) and heroku. 

-- Advanced Testing Setup ##### IMPORTANT ######
- Add minitest/reporters in test/test_helpers.rb as shown here : https://www.railstutorial.org/book/static_pages#sec-minitest_reporters .
  This adds coloring and shows moving from Red to Green
- Update vi config/initializers/backtrace_silencers.rb to remove unwanted lines as shown in https://www.railstutorial.org/book/static_pages#sec-backtrace_silencer
- Setup Guard as given in here : https://www.railstutorial.org/book/static_pages#sec-guard 
** the gem file is already included for guard, make sure
** bundle exec guard init
** update guardfile with guard :minitest, spring: true, all_on_start: false do
** Update .gitignore to ignore spring files : /spring/*.pid
** Open a new terminal window and run : bundle exec guard
** in the prompt enter runs all the tests. 

-- Box 3.4 Unix Processes : https://www.railstutorial.org/book/static_pages#aside-processes 
- ps aux | grep <pattern_to_find>
- kill -9 <process_id>
- pkill -9 -f spring # kill all processes with name spring

DONE. 