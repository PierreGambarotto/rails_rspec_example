rails new todo --skip-test-unit --skip-bundle
cd todo

édition du Gemfile

ajout de 
gem 'therubyracer' # compilateur javascript

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
end

bundle install

git init . 
git add . 
git commit -m "initial commit"

