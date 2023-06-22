# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.2'

set :env_file, '.env'

set :application, 'tic-tac-toe'
set :repo_url, 'git@github.com:nullbr/tic_tac_toe_rails.git'
set :branch, 'main'

# Deploy to the user's home directory
set :deploy_to, "/home/nullbr/#{fetch :application}"

append :linked_files, 'config/master.key', '.env'
