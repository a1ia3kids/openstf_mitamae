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


############################
## stf-provider
############################
template "/lib/systemd/system/stf-provider@#{config["stf-provider"]}.service" do
    variables(base_domain: config[:domain][:base], devside: config[:domain][:devside])
    source 'template/stf-provider@.service.erb'
end

case node[:platform]
when 'redhat'
  execute 'firewall open tcp 7250, 7270 and 15000-25000' do
    user "root"
    command <<-EOC
    firewall-cmd --add-port=7250/tcp --permanent
    firewall-cmd --add-port=7270/tcp --permanent
    firewall-cmd --add-port=15000-25000/tcp --permanent
    firewall-cmd --reload
    EOC
  end

  execute 'sed serial' do
    user "root"
    command <<-EOC
    grep -rl 'serial' /lib/systemd/system/stf-provider@#{config["stf-provider"]}.service | xargs sed -i -e 's/serial/<%= serial %>/g'
    EOC
  end

  execute 'sed publicPort' do
    user "root"
    command <<-EOC
    grep -rl 'publicPort' /lib/systemd/system/stf-provider@#{config["stf-provider"]}.service | xargs sed -i -e 's/publicPort/<%= publicPort %>/g'
    EOC
  end

  execute 'systemctl daemon-reload' do
    user "root"
    command <<-EOC
    systemctl daemon-reload
    EOC
  end
end

service "stf-provider@#{config["stf-provider"]}" do
    action [:enable, :restart]
end

############################
## stf-reaper
############################
template "/lib/systemd/system/stf-reaper.service" do
    variables(appside: config[:domain][:appside], devside: config[:domain][:devside])
    source 'template/stf-reaper.service.erb'
end

service "stf-reaper" do
    action [:enable, :restart]
end

case node[:platform]
when 'redhat'
  execute 'firewall open tcp 7270 and 7150' do
    user "root"
    command <<-EOC
    firewall-cmd --add-port=7270/tcp --permanent
    firewall-cmd --add-port=7150/tcp --permanent
    firewall-cmd --reload
    EOC
  end
end

############################
## stf-storage-plugin-apk
############################
template "/lib/systemd/system/stf-storage-plugin-apk@#{config[:ports]["stf-storage-plugin-apk"]}.service" do
    variables(base_domain: config[:domain][:base])
    source 'template/stf-storage-plugin-apk@.service.erb'
end

service "stf-storage-plugin-apk@#{config[:ports]["stf-storage-plugin-apk"]}" do
    action [:enable, :restart]
end

############################
## stf-storage-plugin-image
############################
template "/lib/systemd/system/stf-storage-plugin-image@#{config[:ports]["stf-storage-plugin-image"]}.service" do
    variables(base_domain: config[:domain][:base])
    source 'template/stf-storage-plugin-image@.service.erb'
end

service "stf-storage-plugin-image@#{config[:ports]["stf-storage-plugin-image"]}" do
    action [:enable, :restart]
end

############################
## stf-storage-plugin-temp
############################
template "/lib/systemd/system/stf-storage-plugin-temp@#{config[:ports]["stf-storage-plugin-temp"]}.service" do
    source 'template/stf-storage-plugin-temp@.service'
end

service "stf-storage-plugin-temp@#{config[:ports]["stf-storage-plugin-temp"]}" do
    action [:enable, :restart]
end

############################
## stf-triproxy-app
############################
template "/lib/systemd/system/stf-triproxy-app.service" do
    source 'template/stf-triproxy-app.service'
end

service "stf-triproxy-app" do
    action [:enable, :restart]
end

case node[:platform]
when 'redhat'
  execute 'firewall open tcp 7160, 7170 and 7260' do
    user "root"
    command <<-EOC
    firewall-cmd --add-port=7160/tcp --permanent
    firewall-cmd --add-port=7170/tcp --permanent
    firewall-cmd --add-port=7260/tcp --permanent
    firewall-cmd --reload
    EOC
  end
end

############################
## stf-triproxy-dev
############################
template "/lib/systemd/system/stf-triproxy-dev.service" do
    source 'template/stf-triproxy-dev.service'
end

service "stf-triproxy-dev" do
    action [:enable, :restart]
end
