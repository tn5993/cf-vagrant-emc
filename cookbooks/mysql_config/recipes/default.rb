#
# Cookbook Name:: cookbooks/mysql
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
mysql_service 'server' do
  initial_root_password 'password'
  version '5.5'
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end
