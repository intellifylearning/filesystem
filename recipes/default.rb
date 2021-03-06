#
# Cookbook:: filesystem
# Recipe:: default
#
# Copyright:: 2013-2017, Alex Trull
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case node['platform_family']
when 'debian'
  package %w(xfsprogs xfsdump xfslibs-dev)
when 'rhel', 'fedora'
  package %w(xfsprogs xfsprogs-devel)
end

# We want to support LVM
include_recipe 'lvm'

# If we have contents at the default location, we try to make the filesystems with the LWRP.
filesystem_create_all_from_key 'filesystems' do
  action :create
  not_if { node['filesystems'].nil? || node['filesystems'].empty? }
end
