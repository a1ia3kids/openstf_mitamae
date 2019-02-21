template '/lib/systemd/system/adbd.service' do
    source 'template/adbd.service'
end

service 'adbd' do
    action [:enable, :restart]
end
