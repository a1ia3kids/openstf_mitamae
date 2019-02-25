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
