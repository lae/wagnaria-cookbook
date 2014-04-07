# encoding: UTF-8
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
include_recipe "supervisor"
include_recipe "apt"

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

directory "#{node[:wagnaria][:destination]}/shared/env" do
  owner node[:wagnaria][:user]
  group node[:wagnaria][:group]
  recursive true
  mode "0755"
end

execute "install python3" do
  command "apt-get -y install python3"
  ignore_failure true
  action :nothing
end.run_action(:run)

#package "python3"

python_virtualenv node[:wagnaria][:virtualenv] do
  interpreter "python#{node[:wagnaria][:pyenv][:version]}"
  owner "root"
  action :create
end

application "wagnaria" do
  path node[:wagnaria][:destination]
  packages ["git-core"]

  owner node[:wagnaria][:user]
  group node[:wagnaria][:group]
  repository node[:wagnaria][:repo]
  revision node[:wagnaria][:tag]
  #migrate true

#  gunicorn do
#    requirements "requirements.txt"
#    app_module "wagnaria:app"
#    preload_app true
#    worker_class "egg:gunicorn#gevent"
#    workers node[:cpu][:total].to_i + 1
#    worker_class "sync"
#    port node[:wagnaria][:gunicorn][:port]
#    virtualenv venv
#  end
end

python_pip "-r #{node[:wagnaria][:destination]}/current/requirements.txt" do
  virtualenv node[:wagnaria][:virtualenv]
  action :install
end

gunicorn_config "/etc/gunicorn/wagnaria.py" do
  action :create
  worker_processes 4
  listen "unix:/tmp/gunicorn-wagnaria.sock"
#  errorlog "/home/wagnaria/errors.log"
  preload_app true
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "/etc/nginx/nginx.conf" do
  notifies :reload, "service[nginx]"
end

template "#{node.nginx.dir}/sites-available/wagnaria" do
  source "wagnaria.erb"
  mode 0777
  owner node.nginx.user
  group node.nginx.user
  notifies :reload, "service[nginx]"
end

nginx_site "wagnaria" do
  enable true
end

template "/etc/supervisor.d/wagnaria.conf" do
  source "wagnaria.supervisor.erb"
end

service "supervisor" do
  action :restart
end

execute "add spess as example show" do
  command "mongo wagnaria --eval '" + 'db.shows.save({ "_id" : ObjectId("526e60f01a61cc191c200efd"), "airtime" : ISODate("2013-12-21T14:30:00Z"), "status" : "airing", "episodes" : { "current" : 86, "total" : 9999 }, "titles" : { "short" : "Spess", "japanese" : "宇宙兄弟", "english" : "Space Brothers" }, "link" : "http://commiesubs.com/category/space-bros/", "progress" : { "edited" : false, "typeset" : false, "timed" : false, "qc" : false, "translated" : false, "encoded" : false }, "staff" : { "translator" : { "name" : "Crunchyroll" }, "typesetter" : { "id" : ObjectId("519a44dd7b43117be1a56202") }, "editor" : { "id" : ObjectId("519a44dd7b43117be1a56201") }, "timer" : { "id" : ObjectId("519a44dd7b43117be1a56202") } }, "channel" : "Crunchyroll", "folders" : { "ftp" : "Space Brothers", "xdcc" : "Space Brothers" } }); db.staff.save({ "_id" : ObjectId("519a44dd7b43117be1a56202"), "name" : "herkz" }); db.staff.save({ "_id" : ObjectId("519a44dd7b43117be1a56201"), "name" : "jdp" });' + "'"
  ignore_failure true
  action :nothing
end
