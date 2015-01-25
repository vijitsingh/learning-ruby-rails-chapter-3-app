

-- Add structure and Bootstrap classes to layout
- Create new branch
- Upate /app/views/layouts/application_layout.erb 
- Add some more stuff in /app/views/sample_app/home.html.erb to add more links. 
- rails server

-- Adding custom CSS for styling and bootstrap
- in the gemfile add a line for "gem 'bootstrap-sass', '3.2.0.0'"
- bundle install
- create and add lines to include bootstrap : /app/assets/stylesheets/custom.css.scss # This should automatically get included
- rails server # page is more styled now. 
- Added more custom css to style the spacing, typography and logo. 

-- Partials
- created app/views/layouts/_header.home.erb and moved the header content to it. 
- Include this file in application.html.erb by : <%= render "layouts/header"
- Create a footer file Add content for a footer file in a similar way as footer and also add some styles for it. 
- rails server 

-- SASS
- update our custom.css.scss to use bootstrap-variables and nesting.

-- Layout links
- Add a contact page by following the "Red-To-Green" TDD approach
- Update routes.rb in this format : get 'help' => 'static_pages#help' . # This would automatically generate help_path and help_url
- Update header and footer partials with links like help_path

-- Layout link tests 
- rails generate integration_test site_layout
- Add integration tests to tests/integration/site_layout_test.rb
- bundle exec rake test:integration # to run integration tests only, just test runs all the tests. 

-- Adding the signup page and User controller
- rails generate controller Users new
- get 'signup' => 'users#new' to routes.rb
- Update home.html.erb with signup_path
- Add custom HTML to the users/new.html.erb
- rails server. 

- Deploy to heroku and git.

DONE. 