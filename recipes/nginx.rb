# install nginx

iptables_rule '45_nginx-ports'


include_recipe 'chef_nginx::default'
include_recipe 'chef_nginx::http_stub_status_module'


template "#{node['consul-server']['nginx-site-path']}" do
  source   'consul-server.conf.erb'
  owner    node['nginx']['user']
  group    node['nginx']['group']
  mode     '0644'
  notifies :enable, "nginx_site[#{node['consul-server']['nginx-site']}]", :immediately
  notifies :reload,  'service[nginx]', :delayed
end

template "#{node['consul-server']['nginx-basicauth-site-path']}" do
  source   'consul-server-basicauth.conf.erb'
  owner    node['nginx']['user']
  group    node['nginx']['group']
  mode     '0644'
  notifies :enable, "nginx_site[#{node['consul-server']['nginx-basicauth-site']}]", :immediately
  notifies :reload,  'service[nginx]', :delayed
end


nginx_site "#{node['consul-server']['nginx-site']}" do
  enable true
  action  :nothing
end

nginx_site "#{node['consul-server']['nginx-basicauth-site']}" do
  enable true
  action  :nothing
end

cookbook_file "#{node['nginx']['logrotate-path']}" do
  source 'nginx-logrotate'
  owner  'root'
  group  'root'
  mode   '0644'
end

# have to fix this
cookbook_file "#{node['consul-server']['nginx-htpasswd-file']}" do
  source   'htpasswd'
  owner    node['nginx']['user']
  group    node['nginx']['group']
  mode     '0600'
end
