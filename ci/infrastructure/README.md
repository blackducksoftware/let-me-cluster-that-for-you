# NGI (Next Generation Infrastructure)

This uses terraform to dynamically create a cluster in a supported cloud provider and install a supported cluster manager.

The currently supported cloud providers are:

- AWS
- VMWare vSphere

The currently supported cluster managers are:

- Openshift Origin
- Kubernetes
- Docker Swarm

Only one cluster can be created at a time.  If a new cluster is started while a previous cluster is still running, then the running cluster will be torn down before the new one is created.

## Configuration File

The specifics on what cloud provider to use, what cluster manager to install, and the cluster composition is controlled by a configuration file.

### Required directives

The following configuration directives are required to be provided in the configuration file.

- **cluster_provider** - The name of the provider where the cluster will be deployed
- **cluster_prefix** - A unique string that will be prefixed to all resources created.  This MUST be unique to avoid conflicts with any other clusters running in the same user space
- **cluster_manager** - The name of the cluster manager to install
- **cluster_docker_version** - The version of docker to install on the cluster instances

### Optional directives

The following configuration directives are optional.  If they are not provided then a default will be used.

- **cluster_manager_version** - The version of the cluster manager to install.  This is needed by any cluster manager other than what docker provides (ie kubernetes, openshift)
- **cluster_masters** - The number of master instances to create in the cloud provider.  This defaults to 1.  Currently only 1 master is supported.
- **cluster_workers** - The number of worker instances to create in the cloud provider.  This defaults to 2.
- **cluster_master_image** - The image to use for the master nodes.  This image must already exist and be accessible in the cloud provider.  The default is specific to the cloud provider used.
- **cluster_worker_image** - The image to use for the worker nodes.  This image must already exist and be accessible in the cloud provider.  The default is specific to the cloud provider used.
- **cluster_bastion_image** - image to use for the bastion node.  This image must already exist and be acceesible in the cloud provider.  The default is specific to the cloud procider used.
- **cluster_region** - The region used to deploy the cluster.  The default is specific to the cloud provider used.
- **cluster_vpc_cidr** - The CIDR block for the VPC.  The default is specific to the cloud provider used.
- **cluster_subnet_cidr** - The CIDR block for the public subnet.  The default is specific to the cloud provider used.
- **cluster_key_name** - The name of the key to user for ssh access.  This defaults to ${cluster_prefix}-cluster-keypair.
- **cluster_public_key_path** - The file on the local system containing the public key to inject into the instances in the cloud provider.  This defaults to ~/.ssh/id_rsa.pub.
- **cluster_private_key_path** - The file on the local system containing the private key that matches the cluster_public_key_path.  This defaults to ~/.ssh/id_rsa.
- **cluster_ssh_user** - The user with ssh access to the master and worker instances in the cloud provider.  The default is specifc to the cloud provider used.
- **cluster_ssh_user_password** - The password to the user with ssh access to the master and worker instances in the cloud provider.  This only needed if the instances being spun up are not able to be configured for passwordless ssh access remotely.  This is only used to configure passwordless ssh access, after which ssh keys are used.
- **cluster_bastion_ssh_user** - The user with ssh access to the bastion image.  The default is specific to the cloud provider used.
- **cluster_bastion_ssh_user_password** - The password to the user with ssh access to the bastion instance in the cloud provider.  This only needed if the instance being spun up are not able to be configured for passwordless ssh access remotely.  This is only used to configure passwordless ssh access, after which ssh keys are used.
- **cluster_instance_create_timeout_minutes** - The number of minutes to wait before determining there was a failure creating an instance.
- **cluster_provider_user** - The username to use when accessing the cluster provider.
- **cluster_provider_password** - The password for the user that can access the cluster provider.
- **cluster_provider_server** - The hostname/ip of the provider server.
- **cluster_provider_resource_pool** - The name of the vSphere resource pool to use.
- **cluster_provider_network** - The name of the vSphere network to use.
- **cluster_provider_datacenter** - The name of the vSphere datacenter to use.
- **cluster_provider_datastore** - The name of the vSphere datastore to use.
- **cluster_bastion_cpus** - The number of cpus to give to the bastion instance.  This is only needed for providers who don't associate cpus with an image.
- **cluster_master_cpus** - The number of cpus to give to the master instances.  This is only needed for providers who don't associate cpus with an image.
- **cluster_worker_cpus** - The number of cpus to give to the worker instances.  This is only needed for providers who don't associate cpus with an image.
- **cluster_bastion_memory_megs** - The amount of memory, in megabytes, to give to the bastion instance.  This is only needed for providers who don't associate memory with an image.
- **cluster_master_memory_megs** - The amount of memory, in megabytes, to give to the master instance.  This is only needed for providers who don't associate memory with an image.
- **cluster_worker_memory_megs** - The amount of memory, in megabytes, to give to the worker instance.  This is only needed for providers who don't associate memory with an image.
- **cluster_min_free_space_gb** - The minimun free space to install the cluster.  This will be passed to the cluster installer if the cluster installer supports it.

## Prerequisites

Before launching a cluster the system needs to be configured with some support tools.  The user creating the cluster must have the terraform binary in their path and have the support libaries installed and configured for all supported cloud providers.  These prerequisites can be taken care of manually or by running the setup/bootstrap command.

## Creating A Cluster

Use the create-cluster command to create a cluster and pass it a configuration file that defines the cluster to be created.  This command will initialize the directory where it is run and launch the cluster.  It will also create a symlink called current-config in the directory where it is run.  The current-config symlink is used by other commands to know which configuration was used to launch the cluster.

## Deleting A Cluster

Use destroy-cluster to teardown the running cluster.  This command uses the current-config symlink created by create-cluster to know what resources need to be deleted.

## Getting A Value From A Running Cluster

A running cluster has a number of variables that can be querried.  These include:

- **master-public-dns** - The publicly accessible DNS name for the master instance
- **master-public-ips** - The public IP address of the master instance
- **worker-public-dns** - A list of publicly accessible DNS names for the worker instances
- **worker-public-ips** - A list of public IP addresses for the worker instances
- **bastion-public-dns** - The publicly accessible DNS name for the bastion instance
- **bastion-public-ip** - The public IP address of the bastion instance
- **cluster-master-url** - The publicly accessible URL to access the master node of the cluster manager
