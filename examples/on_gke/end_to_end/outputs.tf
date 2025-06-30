/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = module.forseti.suffix
}

output "forseti-client-vm-name" {
  description = "Forseti Client VM name"
  value       = module.forseti.forseti-client-vm-name
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = module.forseti.forseti-client-vm-ip
}

output "forseti-client-service-account" {
  description = "Forseti Client service account"
  value       = module.forseti.forseti-client-service-account
}

output "forseti-server-vm-name" {
  description = "Forseti Server VM name"
  value       = module.forseti.forseti-server-vm-name
}

output "forseti-server-vm-ip" {
  description = "Forseti Server VM private IP address"
  value       = module.forseti.forseti-server-vm-ip
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = module.forseti.forseti-server-service-account
}

output "forseti-client-storage-bucket" {
  description = "Forseti Client storage bucket"
  value       = module.forseti.forseti-client-storage-bucket
}

output "forseti-server-storage-bucket" {
  description = "Forseti Server storage bucket"
  value       = module.forseti.forseti-server-storage-bucket
}

