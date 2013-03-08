#
# Cookbook Name:: sensu
# Recipe:: runsvdir_enable
#
# Copyright 2008-2010, Opscode, Inc.
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

# TODO: This needs RHEL support
case node["platform"]
when "ubuntu"
  include_recipe "sensu::runsvdir_upstart"
when "redhat","centos","rhel","scientific"
  if node['platform_version'] =~ /^6/
    include_recipe "sensu::runsvdir_upstart"
  else
    include_recipe "sensu::runsvdir_sysvinit"
  end
else
  include_recipe "sensu::runsvdir_sysvinit"
end
