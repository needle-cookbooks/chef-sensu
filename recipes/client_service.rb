#
# Cookbook Name:: sensu
# Recipe:: client_service
#
# Copyright 2012, Sonian Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node.sensu.init_scheme
when 'init'
  service_provider = case node.platform_family
  when /windows/
    Chef::Provider::Service::Windows
  when /debian/
    Chef::Provider::Service::Init::Debian
  else
    Chef::Provider::Service::Init::Redhat
  end

  service "sensu-client" do
    provider service_provider
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
  end
when 'runit'
  include_recipe 'sensu::runsvdir_enable'
  runit_service 'sensu-client' do
    sv_bin ::File.join(node.sensu.home,'embedded','bin','sv')
    sv_dir ::File.join(node.sensu.home,'sv')
    service_dir ::File.join(node.sensu.home,'service')
    sv_templates false
    subscribes :restart, resources('ruby_block[sensu_service_trigger]'), :delayed
  end
else
  Chef::Log.fatal("Sorry, #{node.sensu.init_scheme} init scheme is not supported")
end
