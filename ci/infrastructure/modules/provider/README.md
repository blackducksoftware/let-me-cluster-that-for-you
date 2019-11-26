# NGI Provider Module

This directory contains all the modules to support various cloud providers.  Each cloud provider's implementation is contained in a subdirectory.

## The Cloud Provider Module

The Cloud Provider Module is an abstraction above various cloud provider implementations.   It provides a common interface to cloud provider instance information regardless of what cloud provider is actually used.  This is accomplished by providing a set of configuration and output variables that are independent from the cloud provider used and relying upon the cloud provider module to perform the necessary tasks based upon the provided configuration variables and output the data required to meet the Cloud Provider Module's output variables.

### Configuration Variables

#### Required directives

The following variables are required when configuring the Cloud Provider Module:

- **provider_prefix** - The prefix to prepend to all resources.
- **provider_master_count** - The number of master instances to create.
- **provider_worker_count** - The number of worker instance to create.
- **provider_name** - The name of the provider to use.
- **provider_key_name** - The name of the keypair to create in the cloud provider for ssh access.
- **provider_public_key_path** - The path to a local public key file.
- **provider_private_key_path** - The path to a local private key file.

#### Optional directives

These variables are optional when configuring the Cloud Provider Module.  If a value is not supplied then the cloud provider module will provide a sane default.

- **provider_master_image** - The image to use for the master nodes.
- **provider_worker_image** - The image to use for the worker nodes.
- **provider_bastion_image** - The image to use for the bastion node.
- **provider_region** - The region used to deploy the cluster.
- **provider_vpc_cidr** - The CIDR block for a VPC.
- **provider_subnet_cidr** - The CIDR block for the public subnet.
- **provider_cluster_ssh_user** - The user that can ssh into the master and worker instances.
- **provider_cluster_ssh_user_password** - The password for the user that can ssh into the master and worker instances.  This only needed if the instances being spun up are not able to be configured for passwordless ssh access remotely.  This is only used to configure passwordless ssh access, after which ssh key are used.
- **provider_bastion_ssh_user** - The user than can ssh into the bastion instance.
- **provider_bastion_ssh_user_password** - The user than can ssh into the bastion instance.  This only needed if the instances being spun up are not able to be configured for passwordless ssh access remotely.  This is only used to configure passwordless ssh access, after which ssh key are used.
- **provider_instance_create_timeout** - The number of minutes before deciding a there is a problem with instance creation.
- **provider_user** - The user that can access the provider server.
- **provider_password** - The password for the user that can access the provider server.
- **provider_server** - The provider server.
- **provider_resource_pool** - The name of the resource pool to use on the provider.
- **provider_network** - The name of the network to use on the provider.
- **provider_datacenter** - The name of the datacenter to use on the provider.
- **provider_datastore** - The name of the datastore to use on the provider.
- **provider_bastion_cpus** - The number of cpus to give to the bastion instance.  This is only needed for providers who don't associate cpus with an image.
- **provider_master_cpus** - The number of cpus to give to the master instances.  This is only needed for providers who don't associate cpus with an image.
- **provider_worker_cpus** - The number of cpus to give to the worker instances.  This is only needed for providers who don't associate cpus with an image.
- **provider_bastion_memory_megs** - The amount of memory, in megabytes, to give to the bastion instance.  This is only needed for providers who don't associate memory with an image.
- **provider_master_memory_megs** - The amount of memory, in megabytes, to give to the master instance.  This is only needed for providers who don't associate memory with an image.
- **provider_worker_memory_megs** - The amount of memory, in megabytes, to give to the worker instance.  This is only needed for providers who don't associate memory with an image.

### Output Variables

The Cloud Provider Module will output the following variables:

- **master-public-dns** - The publicly accessible DNS name for the master instance.
- **master-public-ips** - The publicly accessible IP address for the master instance.
- **master-private-dns** - The private DNS name for the master instance.
- **master-private-ips** - The private IP address for the master instance.
- **worker-public-dns** - A list of the publicly accessible DNS names for the worker instances.
- **worker-public-ips** - A list of the publicly accessible IP addresses for the worker instance.
- **worker-private-dns** - A list of the private DNS name for the worker instances.
- **worker-private-ips** - A list of the the private IP addresse for the worker instances.
- **bastion-public-dns** - The publicly accessible DNS name for the bastion instance.
- **bastion-public-ips** - The publicly accessible IP address for the bastion instance.
- **bastion-private-dns** - The private DNS name for the bastion instance.
- **bastion-private-ips** - The private IP address for the bastion instance.
- **cluster-ssh-user** - The username that can access the master and worker instances via SSH.
- **bastion-ssh-user** - The username that can access the bastion instance via SSH.

## Adding A New Cloud Provider

Adding support for a new cloud provider is pretty straight forward.  In addition to creating terraform implementation files in a subdirectory there are a few requirements that a cloud provider module must meet.

A cloud provider module should only create terraform resources if it is configured.  This is managed by setting the count for all entities in the cloud provider module to 0 if that provider is not configured.

### Responsibilities

A cloud provider module must do the following:

- Spin up instances
- Configure internal/external network access
- Update to latest packages
- Any configuration necessary to enable docker installation.  This is ususally creating a separate disk for docker storage.  It should NOT install docker

### Available Configuration Variables

A cloud provider module can be configured using the following configuration variables:

- **provider_master_image** - The image to use for the master nodes.
- **provider_worker_image** - The image to use for the worker nodes.
- **provider_bastion_image** - The image to use for the bastion node.
- **provider_region** - The region used to deploy the cluster.
- **provider_vpc_cidr** - The CIDR block for a VPC.
- **provider_subnet_cidr** - The CIDR block for the public subnet.
- **provider_prefix** - The prefix to prepend to all resources.
- **provider_master_count** - The number of master instances to create.
- **provider_worker_count** - The number of worker instance to create.
- **provider_name** - The name of the provider to use.
- **provider_key_name** - The name of the keypair to create in the cloud provider for ssh access.
- **provider_public_key_path** - The path to a local public key file.
- **provider_private_key_path** - The path to a local private key file.
- **provider_cluster_ssh_user** - The user that can ssh into the cluster instances (both master and worker).
- **provider_bastion_ssh_user** - The user that can ssh into the bastion instance.
- **provider_instance_create_timeout** - The number of minutes before deciding a there is a problem with instance creation.
- **provider_user** - The user that can access the provider server.
- **provider_password** - The password for the user that can access the provider server.
- **provider_server** - The provider server.
- **provider_resource_pool** - The name of the resource pool to use on the provider.
- **provider_network** - The name of the network to use on the provider.
- **provider_datacenter** - The name of the datacenter to use on the provider.
- **provider_datastore** - The name of the datastore to use on the provider.
- **provider_bastion_cpus** - The number of cpus to give to the bastion instance.  This is only needed for providers who don't associate cpus with an image.
- **provider_master_cpus** - The number of cpus to give to the master instances.  This is only needed for providers who don't associate cpus with an image.
- **provider_worker_cpus** - The number of cpus to give to the worker instances.  This is only needed for providers who don't associate cpus with an image.
- **provider_bastion_memory_megs** - The amount of memory, in megabytes, to give to the bastion instance.  This is only needed for providers who don't associate memory with an image.
- **provider_master_memory_megs** - The amount of memory, in megabytes, to give to the master instance.  This is only needed for providers who don't associate memory with an image.
- **provider_worker_memory_megs** - The amount of memory, in megabytes, to give to the worker instance.  This is only needed for providers who don't associate memory with an image.

#### Default Values

A cloud provider module must provide sensible defaults for the following data:

- The image to use for the master nodes
- The image to use for the worker nodes
- The image to use for the bastion node
- The region used to deploy the cluster
- The CIDR block for a VPC
- The CIDR block for the public subnet
- The user who can ssh into the master and worker instances
- The user who van ssh into the bastion instance

These values MUST be able to be overridden by the caller.

### Required Output Variables

A cloud provider module MUST provide the following information as output variables:

- Public DNS name for the master instance
- Public IP address for the master instance
- Private DNS name for the master instance
- Private IP address for the master instance
- Public DNS name for the worker instances
- Public IP address for the worker instances
- Private DNS name for the worker instances
- Private IP address for the worker instances
- Public DNS name for the bastion instance
- Public IP address for the bastion instance
- Private DNS name for the bastion instance
- Private IP address for the bastion instance
- The user who can ssh into the master and worker instances
- The user who van ssh into the bastion instance

If the cloud provider is NOT configured then these output variables MUST be empty (either empty lists or empty strings).

### Hooking Into The Cloud Provider Module

Once a cloud provider implementation has been written it needs to be plugged into the Cloud Provider Module.  To do so, several modifications to the exsiting terraform files must be implemented:

- Create a directory that contains all the terraform configuration files for the provider
- Add a configuration file in configs named <provider>.tf, where <provider> is the name of the provider.  This should be the same name used to enable to provider in config.  The module MUST be named "cloud".
