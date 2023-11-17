# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "my_app_name"
set :repo_url, "git@example.com:me/my_repo.git"
# set :deploy_to, "/var/www/my_app_name"
append :linked_files, "config/master.key"
