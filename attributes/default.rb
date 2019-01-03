

default['nginx']['conf_cookbook']        = 'consul-server'
default['nginx']['conf_template']        = 'nginx.conf.erb'
default['nginx']['default_site_enabled'] = false
default['nginx']['worker_processes']     = '6'
default['nginx']['worker_connections']   = '1024'
default['nginx']['enable-access-log']    = 'true'
default['nginx']['logrotate-path']       = "/etc/logrotate.d/nginx"

default['consul-server']['secrets']['bucket'] = ''
default['consul-server']['secrets']['bucket_region'] = ''
default['consul-server']['secrets']['file'] = ''
default['consul-server']['server-count'] = 0
default['consul-server']['system-packages'] = %w() 

default['consul-server']['nginx-ports']          = %w(80)
default['consul-server']['nginx-basicauth-port'] = '8081'
default['consul-server']['ui-port']         = '8500'
default['consul-server']['nginx-site']      = 'consul'
default['consul-server']['nginx-site-path'] = "#{node['nginx']['dir']}/sites-available/#{node['consul-server']['nginx-site']}"
default['consul-server']['nginx-basicauth-site']      = 'consul-basicauth'
default['consul-server']['nginx-basicauth-site-path'] = "#{node['nginx']['dir']}/sites-available/#{node['consul-server']['nginx-basicauth-site']}"
default['consul-server']['nginx-conf-path']     = "#{node['nginx']['dir']}/conf.d/consul-service.conf"
default['consul-server']['nginx-htpasswd-file'] = "#{node['nginx']['dir']}/htpasswd"

# oauth stuff
default['consul-server']['oauth']['github-org']   = 'YOUR-GITHUB-ORG-HERE'
default['consul-server']['oauth']['listen-port']  = ':8080'
default['consul-server']['oauth']['upstream-url'] = 'http://127.0.0.1:80/'

default['consul-server']['oauth']['client-id']     = ''
default['consul-server']['oauth']['client-secret'] = ''
default['consul-server']['oauth']['cookie-expiry'] = '1h'

default['consul-server']['oauth']['user']   = 'www-data'
default['consul-server']['oauth']['group']  = 'www-data'
default['consul-server']['oauth']['env']    = {}
default['consul-server']['oauth']['binary'] = '/usr/local/bin/oauth-proxy'
default['consul-server']['oauth']['config'] = '/etc/oauth.cfg'

default['dnsmasq']['enable_dns'] = false
default['consul-server']['dnsmasq-file']  = '/etc/dnsmasq.d/10-consul.conf'
default['consul-server']['dnsmasq-user']  = 'root'
default['consul-server']['dnsmasq-group'] = 'root'
default['consul-server']['resolved-file'] = '/etc/systemd/resolved.conf'

default['consul-server']['consul-dns-ip'] = '127.0.0.54'
default['consul-server']['backup-script'] = '/usr/local/bin/consul-backup.sh'
default['consul-server']['backup-hours']  = '2,10,18'

#default['consul-server']['recursors']    = %w(127.0.0.1)

default['consul-server']['ssl-dir'] = '/etc/consul/ssl'

default['consul-server']['verify-incoming']        = false
default['consul-server']['verify-outgoing']        = false
default['consul-server']['verify-server-hostname'] = false

default['consul-server']['ca-cert']['file']   = "#{node['consul-server']['ssl-dir']}/ca.cert"
default['consul-server']['ca-cert']['bucket'] = ''
default['consul-server']['ca-cert']['key']    = ''

default['consul-server']['server-cert']['file']   = "#{node['consul-server']['ssl-dir']}/server.cert"
default['consul-server']['server-cert']['bucket'] = ''
default['consul-server']['server-cert']['key']    = ''

default['consul-server']['server-key']['file']   = "#{node['consul-server']['ssl-dir']}/server.key"
default['consul-server']['server-key']['bucket'] = ''
default['consul-server']['server-key']['key']    = ''
