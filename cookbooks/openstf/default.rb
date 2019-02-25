config = node[:config]

############################
## adbd
############################
template '/lib/systemd/system/adbd.service' do
    source 'template/adbd.service'
end

service 'adbd' do
    action [:enable, :restart]
end

############################
## rethinkdb
############################
template '/lib/systemd/system/rethinkdb.service' do
    variables(rethinkdb_key: config[:keys][:rethinkdb_key])
    source 'template/rethinkdb.service.erb'
end

service 'rethinkdb' do
    action [:enable, :restart]
end

case node[:platform]
when 'redhat'
  execute 'firewall open tcp 8080' do
    user "root"
    command <<-EOC
    firewall-cmd --add-port=8080/tcp --permanent
    firewall-cmd --reload
    EOC
  end
end

############################
## rethinkdb-proxy
############################
template '/lib/systemd/system/rethinkdb-proxy-28015.service' do
    variables(rethinkdb_key: config[:keys][:rethinkdb_key], rethinkdb_host: config[:domain][:rethinkdb])
    source 'template/rethinkdb-proxy-28015.service.erb'
end

service 'rethinkdb-proxy-28015' do
    action [:enable, :restart]
end

case node[:platform]
when 'redhat'
  execute 'firewall open tcp 28015' do
    user "root"
    command <<-EOC
    firewall-cmd --add-port=28015/tcp --permanent
    firewall-cmd --reload
    EOC
  end
end

############################
## stf-app
############################
template "/lib/systemd/system/stf-app@#{config[:ports]["stf-app"]}.service" do
    variables(secret_key: config[:keys][:secret_key], base_domain: config[:domain][:base])
    source 'template/stf-app@.service.erb'
end

service "stf-app@#{config[:ports]["stf-app"]}" do
    action [:enable, :restart]
end

############################
## stf-auth
############################
template "/lib/systemd/system/stf-auth@#{config[:ports]["stf-auth"]}.service" do
    variables(secret_key: config[:keys][:secret_key], base_domain: config[:domain][:base])
    source 'template/stf-auth@.service.erb'
end

service "stf-auth@#{config[:ports]["stf-auth"]}" do
    action [:enable, :restart]
end

############################
## stf-migrate
############################
template '/lib/systemd/system/stf-migrate.service' do
    source 'template/stf-migrate.service'
end

service 'stf-migrate' do
    action [:enable, :restart]
end

############################
## stf-processor
############################
template "/lib/systemd/system/stf-processor@#{config["stf-processor"]}.service" do
    variables(appside: config[:domain][:appside], devside: config[:domain][:devside])
    source 'template/stf-processor@.service.erb'
end

service "stf-processor@#{config["stf-processor"]}" do
    action [:enable, :restart]
end

case node[:platform]
when 'redhat'
  execute 'firewall open tcp 7160 and 7260' do
    user "root"
    command <<-EOC
    firewall-cmd --add-port=7160/tcp --permanent
    firewall-cmd --add-port=7260/tcp --permanent
    firewall-cmd --reload
    EOC
  end
end
