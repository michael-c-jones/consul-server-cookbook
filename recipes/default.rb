
node['consul-server']['system-packages'].each do |pkg|
  package pkg
end


include_recipe "iptables"
iptables_rule '40_consul-ports'


key_string = s3_load(
  node['consul-server']['secrets']['bucket_region'],
  node['consul-server']['secrets']['bucket'],
  node['consul-server']['secrets']['file'])
consul_keys = Chef::EncryptedDataBagItem.load(
  node['consul-server']['credentials']['databag_name'],
  node['consul-server']['credentials']['databag_item'],
  key_string)

poise_service_user node['consul']['service_user'] do
  group node['consul']['service_group']
end

include_recipe 'consul-server::dns_setup'

# not anytime soon
#include_recipe 'consul-server::certs'

node.default['consul']['config']['server']              = true
node.default['consul']['config']['node_name']           = node['ec2']['tags']['Name']
node.default['consul']['config']['ui']                  = true
node.default['consul']['config']['bind_addr']           = node['ipaddress']
node.default['consul']['config']['advertise_addr']      = node['ipaddress']
node.default['consul']['config']['disable_remote_exec'] = false
node.default['consul']['config']['advertise_addr_wan']  = node['ipaddress']
node.default['consul']['config']['client_addr']         = "127.0.0.1 #{node['consul-server']['consul-dns-ip']}"
node.default['consul']['config']['encrypt']             = consul_keys['gossip_encryption_key']
node.default['consul']['config']['datacenter']          = node['consul-server']['config']['datacenter']
node.default['consul']['config']['retry_join']          = [ "provider=aws tag_key=consul_dc tag_value=#{node['consul-server']['config']['datacenter']}" ]
node.default['consul']['config']['bootstrap_expect'] = node['consul-server']['count']
node.default['consul']['config']['telemetry']['dogstatsd_addr'] = '127.0.0.1:8125'

node.default['consul']['config']['verify_incoming']        = node['consul-server']['verify-incoming']
node.default['consul']['config']['verify_outgoing']        = node['consul-server']['verify-outgoing']
node.default['consul']['config']['verify_server_hostname'] = node['consul-server']['verify-server-hostname']
node.default['consul']['config']['ports']['dns']           = 53
node.default['consul']['config']['ca_file']                = node['consul-server']['ca-cert']['file']
node.default['consul']['config']['cert_file']              = node['consul-server']['server-cert']['file']
node.default['consul']['config']['key_file']               = node['consul-server']['server-key']['file']

include_recipe 'consul::default'

include_recipe 'consul-server::nginx'
include_recipe 'consul-server::oauth'


cookbook_file "#{node['consul-server']['backup-script']}" do
  source 'consul-backup.sh'
  owner  'root'
  group  'root'
  mode   '0755'
end

cron_d 'backup-consul' do
  minute  "7"
  hour    "#{node['consul-server']['backup-hours']}" 
  command "#{node['consul-server']['backup-script']}"
end

tag("bootstrapped")
