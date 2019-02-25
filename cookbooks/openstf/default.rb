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
