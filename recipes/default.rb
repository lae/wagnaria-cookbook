#
# Cookbook Name:: wagnaria
# Recipe:: default
#
# All rights reserved - Do Not Redistribute
#
include_recipe "gunicorn"
include_recipe "nginx"
include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"
#include_recipe "git"
package "python3"

group node[:wagnaria][:group]

user node[:wagnaria][:user] do
  group node[:wagnaria][:group]
  system true
  shell "/bin/bash"
end

directory node[:wagnaria][:destination] do
  owner node[:wagnaria][:user]
  group node[:wagnaria][:group]
  recursive true
  mode "0755"
end

venv = "#{node[:wagnaria][:destination]}/shared/env"

python_virtualenv venv do
  interpreter "python#{node[:wagnaria][:pyenv][:version]}"
  owner "root"
  action :create
end

application "wagnaria" do
  path node[:wagnaria][:destination]
  packages ["git-core", "python3"]

  repository node[:wagnaria][:repo]
  revision node[:wagnaria][:tag]
  migrate true
  owner node[:wagnaria][:user]
  group node[:wagnaria][:group]

  gunicorn do
    packages node[:wagnaria][:pyenv][:packages]
    app_module "wagnaria:app"
#    preload_app true
    worker_class "egg:gunicorn#gevent"
    workers node[:cpu][:total].to_i + 1
    port node[:wagnaria][:gunicorn][:port]
    virtualenv venv
  end
end

nginx_conf_file "wagnaria" do
  socket "127.0.0.1:#{node[:wagnaria][:gunicorn][:port]}"
  server_name "_"
end
