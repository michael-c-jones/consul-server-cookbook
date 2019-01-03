

# setup dns name resolution so consul names like kafka.service.consul resolve correctly.
# for ubuntu 17 and higher, they use systemd-resolved rather than bind.  Using dnsmasq
# on newer hosts causes contention between systemd-resolved and dnsmasq reading to really
# high CPU consumption.
#
# So for these hosts, we need to remove dnsmasq if it's there, and replace it whith a custom resolver
# referenced from /etc/systemd/resolve.conf.  Because that file can't reference a custom port, we need
# to have consul dns to resolve on one of the fake 127.0.0.XXX interfaces.


if node['platform'] == 'ubuntu' && node['platform_version'].to_f > 16.04

  # first stop dnsmasq and remove it if the package is installed
  package 'dnsmasq' do
    action :purge
    only_if { node['packages'].keys.include?('dnsmasq') }
  end

  # configure systemd-resolved
  template node['consul-server']['resolved-file'] do
    source   'resolved.conf.erb'
    owner    'root'
    group    'root'
    mode     '0644'
    notifies :restart, 'systemd_unit[systemd-resolved]', :immediately
  end

  systemd_unit 'systemd-resolved' do
    action :nothing
  end

else 

  # these older hosts can just run dnsmasq 
  include_recipe "dnsmasq"

  template node['consul-server']['dnsmasq-file'] do
    source   "dnsmasq.erb"
    owner    node['consul-server']['dnsmasq-user']
    group    node['consul-server']['dnsmasq-group']
    mode     '0644'
    notifies :restart, 'service[dnsmasq]', :immediately
  end

end
