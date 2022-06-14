# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

title 'Forseti Terraform GCP Test Suite for Shared VPC setup'

service_project_id      = attribute("service_project_id")
shared_project_id       = attribute("shared_project_id")
forseti_server_vm_name  = attribute("forseti_server_vm_name")
forseti_server_vm_ip    = attribute("forseti_server_vm_ip")
forseti_client_vm_name  = attribute("forseti_client_vm_name")
forseti_client_vm_ip    = attribute("forseti_client_vm_ip")
region                  = attribute("region")
network_name            = attribute('network_name')
subnetwork_self_link    = attribute('subnetwork_self_link')
credentials_path        = attribute('credentials_path')

control 'forseti-service-project' do
  impact 1.0
  title 'test forseti project'
  describe google_compute_project_info(project: service_project_id) do
    its('xpn_project_status') { should eq 'UNSPECIFIED_XPN_PROJECT_STATUS' }
    its('name') { should eq service_project_id}
  end
end

control 'forseti-shared-project' do
  impact 1.0
  title 'test shared project'
  describe google_compute_project_info(project: shared_project_id) do
    its('xpn_project_status') { should eq 'HOST' }
    its('name') { should eq shared_project_id}
  end
end

control 'shared-network' do
  impact 1.0
  title 'test shared vpc'
  describe google_compute_network(project: shared_project_id,  name: network_name) do
    it { should exist }
    its('name') { should eq network_name }
    its ('subnetworks.count') { should eq 1 }
    its ('subnetworks.first') { should include subnetwork_self_link}
    its ('auto_create_subnetworks'){ should be false }
    its ('routing_config.routing_mode') { should eq "GLOBAL" }
  end
end

control 'forseti-networks' do
  impact 1.0
  title 'Forseti project has not VPCs'
  describe google_compute_networks(project: service_project_id) do
    it { should_not exist }
  end
end

control 'forseti-server' do
  impact 1.0
  title 'test forseti server'
  describe google_compute_instance(project: service_project_id,  zone: "#{region}-c", name: forseti_server_vm_name) do
    it { should exist }
    its('has_disks_encrypted_with_csek?') { should be false }
    its('status') { should eq 'RUNNING' }
    its('disk_count'){should eq 1}
  end
end

control 'forseti-client' do
  impact 1.0
  title 'test forset client'
  describe google_compute_instance(project: service_project_id,  zone: "#{region}-c", name: forseti_client_vm_name) do
    it { should exist }
    its('has_disks_encrypted_with_csek?') { should be false }
    its('status') { should eq 'RUNNING' }
    its('disk_count'){should eq 1}
  end
end
