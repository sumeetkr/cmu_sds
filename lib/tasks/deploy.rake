namespace :heroku do

  desc "deploy the application to heroku and populate the database with data"
  task :reset => [:deploy, :repopulate] do
    puts `heroku open`
  end

  desc "Push source to heroku"
  task :deploy do
    puts `git push heroku master`
  end

  desc "empty the database by reloading the schema"
  task :empty => [:environment] do
    puts `heroku pg:reset DATABASE --confirm cmusds`
    puts `heroku run rake db:schema:load`
  end

  desc "Load sample data and restart the heroku application"
  task :populate => [:environment] do
    puts `heroku run rake db:populate`
    puts `heroku restart`
  end

  desc "empty and then repopulate the database"
  task :repopulate => [:empty, :populate]

end