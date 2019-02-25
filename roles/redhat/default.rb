config = node[:config]

include_role 'base'

include_cookbook 'docker'
include_cookbook 'openstf'
