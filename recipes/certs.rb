
# drop the ca certificate, server certificate and server key

directory node['consul-server']['ssl-dir'] do
  owner     node['consul']['service_user']
  group     node['consul']['service_group']
  recursive true
  mode      '0700'
end

aws_s3_file node['consul-server']['ca-cert']['file'] do
  bucket      node['consul-server']['ca-cert']['bucket']
  remote_path node['consul-server']['ca-cert']['key']
  region      node['consul-server']['ca-cert']['region']
  owner       node['consul']['service_user']
  group       node['consul']['service_group']
  mode        '0600'
  sensitive true
end


aws_s3_file node['consul-server']['server-cert']['file'] do
  bucket      node['consul-server']['server-cert']['bucket']
  remote_path node['consul-server']['server-cert']['key']
  region      node['consul-server']['ca-cert']['region']
  owner       node['consul']['service_user']
  group       node['consul']['service_group']
  mode        '0600'
  sensitive true
end


aws_s3_file node['consul-server']['server-key']['file'] do
  bucket      node['consul-server']['server-key']['bucket']
  remote_path node['consul-server']['server-key']['key']
  region      node['consul-server']['ca-cert']['region']
  owner       node['consul']['service_user']
  group       node['consul']['service_group']
  mode        '0600'
  sensitive   true
end

