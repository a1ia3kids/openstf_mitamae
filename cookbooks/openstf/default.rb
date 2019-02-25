template '/lib/systemd/system/adbd.service' do
    source 'template/adbd.service'
end

service 'adbd' do
    action [:enable, :restart]
end

case node[:platform]
when 'redhat'
  execute 'old docker remove' do
    user "root"
    command <<-EOC
    docker run --rm -v /srv/rethinkdb:/data rethinkdb:2.3 rethinkdb --initial-password config[:keys][:rethinkdb_key]
    EOC
  end
end

template '/lib/systemd/system/rethinkdb.service' do
    variables(rethinkdb_key: config[:keys][:rethinkdb_key])
    source 'template/rethinkdb.service.erb'
end

service 'rethinkdb' do
    action [:enable, :restart]
end
