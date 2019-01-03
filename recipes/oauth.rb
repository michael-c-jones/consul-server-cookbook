
template "/etc/oauth.cfg" do
  source 'oauth.cfg.erb'
  owner 'root'
  group 'root'
  mode  '0644'
end

cookbook_file '/usr/local/bin/oauth-proxy' do
  source 'oauth2-proxy'
  owner  'root'
  group  'root'
  mode   '0755'
  notifies :restart, "systemd_unit[oauth2-proxy]", :delayed
end




template "/etc/systemd/system/oauth2-proxy.service" do
  source 'oauth2-proxy.service.erb'
  owner 'root'
  group 'root'
  mode  '0644'
  variables({
    :user => node['consul-server']['oauth']['user'],
    :group => node['consul-server']['oauth']['group'],
    :env => node['consul-server']['oauth']['env'],
    :binary => node['consul-server']['oauth']['binary'],
    :config => node['consul-server']['oauth']['config']
  })
  notifies :reload, "systemd_unit[oauth2-proxy]", :immediately
  notifies :restart, "systemd_unit[oauth2-proxy]", :delayed
end


systemd_unit 'oauth2-proxy' do
#  supports :restart =>true, :status => true
  action [ :enable, :start ]
end

