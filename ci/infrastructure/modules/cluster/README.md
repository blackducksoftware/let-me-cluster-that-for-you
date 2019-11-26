# NGI Cluster Module

This directory contains all the modules to support various cluster managers.  Each cluster manager's implementation is contained in a subdirectory.

## The Cluster Module

The Cluster Module is an abstraction above various cluster manager implementations.   It provides a common interface to installing a cluster manager regardless of what cluster manager is actually installed.  This is accomplished by providing a set of configuration and output variables that are independent from the cluster manager used and relying upon the cluster manager implementation to perform the necessary tasks based upon the provided configuration variables and output the data required to meet the Cluster Module's output variables.

### Configuration Variables

The following variables are required when configuring the Cluster Module:

- **cluster_manager_name** - The name of the cluster manager to install
- **cluster_version** - The version of the cluster manager to install
- **cluster_master_count** - The number of masters to install.  Currently only 1 is supported
- **cluster_worker_count** - The number of workers to install
- **cluster_private_key_file** - The private ssh key needed to access cluster nodes (both master and worker)
- **cluster_public_hostname** - The publicly accessible FQDN hostname for accessing the cluster
- **cluster_install_node_public_name** - The publicly accessible FQDN host where the installer will be run
- **cluster_install_node_private_name** - The private DNS friendly name where the installer will be run
- **cluster_subdomain** - The default subdomain for the cluster
- **cluster_master_public_names** - A list of publicly accessible FQDN master nodes
- **cluster_worker_public_names** - A list of publicly accessible FQDN worker nodes
- **cluster_master_private_names** - A list of private DNS friendly names to use as master nodes when creating the cluster
- **cluster_worker_private_names** - A list of private DNS friendly names to use as worker nodes when creating the cluster
- **cluster_ssh_user** - The user that can ssh into the cluster instances, both master and worker
- **cluster_installer_ssh_user** - The user that can ssh into the host that will perform the installation
- **cluster_depends_on** - The id of last task in the module that will install docker
- **cluster_min_free_disk_gb** - The minimum amount of free disk space required to install the cluster manager.  This is passed to the cluster manager installer if it is supported.

### Output Variables

The Cluster Module will output the following variables:

- **master-url** - The publicly accessible url to access the cluster master

## Adding A New Cloud Provider

Adding support for a new cluster manager is pretty straight forward.  In addition to creating terraform implementation files in a subdirectory there are a few requirements that a cluster manager module must meet.

A cluster manager module should only create terraform resources if it is configured.  This is managed by setting the count for all entities in the cluster manager module to 0 if that cluster manager is not configured.

### Available Configuration Variables

A cluster manager module has access to the following configuration variables:

- **cluster_manager_name** - The name of the cluster manager to install
- **cluster_version** - The version of the cluster manager to install
- **cluster_master_count** - The number of masters to install.  Currently only 1 is supported
- **cluster_worker_count** - The number of workers to install
- **cluster_private_key_file** - The private ssh key needed to access cluster nodes (both master and worker)
- **cluster_public_hostname** - The publicly accessible FQDN hostname for accessing the cluster
- **cluster_install_node_public_name** - The publicly accessible FQDN host where the installer will be run
- **cluster_install_node_private_name** - The private DNS friendly name where the installer will be run
- **cluster_subdomain** - The default subdomain for the cluster
- **cluster_master_public_names** - A list of publicly accessible FQDN master nodes
- **cluster_worker_public_names** - A list of publicly accessible FQDN worker nodes
- **cluster_master_private_names** - A list of private DNS friendly names to use as master nodes when creating the cluster
- **cluster_worker_private_names** - A list of private DNS friendly names to use as worker nodes when creating the cluster
- **cluster_ssh_user** - The user that can ssh into the cluster instances, both master and worker
- **cluster_installer_ssh_user** - The user that can ssh into the host that will perform the installation

### Required Output Variables

A cluster manager module MUST provide the following information as output variable:

- Publicly accessible endpoint for the cluster master

If the cluster manager is NOT configured then this output variable MUST be empty.

### Hooking Into The Cluster Module

Once a cluster manager implementation has been written it needs to be plugged into the Cluster Module.  To do so, several modifications to the existing terraform files must be implemented:

- Create a directory that contains all the terraform configuration files for the cluster manager
- Add a module stanza to main.tf and pass in any required variables
- Modify the output.tf to add the output from the cluster manager module to the output variable
