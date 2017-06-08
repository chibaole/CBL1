# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "cbl"
set :pty, true
set :repo_url, "git@github.com:chibaole/CBL1.git"
set :migration_role, :app
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :rbenv_ruby, '2.3.4'
set :rbenv_ruby_dir, '/home/app/.rbenv/versions'
set :rbenv_custom_path, '/home/app/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_custom_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl}

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/cbl"
# set :scm, :git
set :log_level, :info

set :linked_files, fetch(:linked_files, []).push("config/database.yml", ".ruby-version", "config/puma.rb", ".rbenv-vars")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "public/feeds", "tmp/cache")

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
