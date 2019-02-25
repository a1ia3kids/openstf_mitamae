config = node[:config]

template '/lib/systemd/system/adbd.service' do
    source 'template/adbd.service'
end

service 'adbd' do
    action [:enable, :restart]
end

template '/lib/systemd/system/rethinkdb.service' do
    variables(rethinkdb_key: config[:keys][:rethinkdb_key])
    source 'template/rethinkdb.service.erb'
end

service 'rethinkdb' do
    action [:enable, :restart]
end

template '/lib/systemd/system/rethinkdb-proxy-28015.service.erb' do
    variables(rethinkdb_key: config[:keys][:rethinkdb_key], rethinkdb_host: config[:domain][:rethinkdb])
    source 'template/rethinkdb.service.erb'
end

service 'rethinkdb-proxy-28015' do
    action [:enable, :restart]
end
