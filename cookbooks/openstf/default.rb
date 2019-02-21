template 'adbd.service' do
    source '/lib/systemd/system/adbd.service'
end

service 'adbd' do
    action [:enable, :restart]
end
