
case node[:platform]
when 'redhat'
  execute 'old docker remove' do
    user "root"
    command <<-EOC
    yum remove -y docker  docker-client  docker-client-latest  docker-common  docker-latest  docker-latest-logrotate  docker-logrotate  docker-selinux  docker-engine-selinux  docker-engine
    EOC
  end

  [
    "yum-utils",
    "device-mapper-persistent-data",
    "lvm2",
  ].each {| pkg |
    package pkg do
    action :install
  end
  }

  execute 'add docker repository' do
    user "root"
    command <<-EOC
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    EOC
  end

  package 'docker-ce'
  service 'docker' do
    action [:enable, :restart]
  end
else
end
