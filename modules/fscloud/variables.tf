##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to use"
  type        = string
  sensitive   = true
}

# Resource Group Variables
variable "resource_group_id" {
  type        = string
  description = "The Id of an existing IBM Cloud resource group where the cluster will be grouped."
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the cluster will be provisioned."
}

# Cluster Variables
variable "tags" {
  type        = list(string)
  description = "Metadata labels describing this cluster deployment"
  default     = []
}

variable "cluster_name" {
  type        = string
  description = "The name that will be assigned to the provisioned cluster"
}

variable "vpc_subnets" {
  type = map(list(object({
    id         = string
    zone       = string
    cidr_block = string
  })))
  description = "Metadata that describes the VPC's subnets. Obtain this information from the VPC where this cluster will be created"
}

variable "worker_pools" {
  type = list(object({
    subnet_prefix     = string
    pool_name         = string
    machine_type      = string
    workers_per_zone  = number
    resource_group_id = optional(string)
    labels            = optional(map(string))
    boot_volume_encryption_kms_config = optional(object({
      crk             = string
      kms_instance_id = string
      kms_account_id  = optional(string)
    }))
  }))
  description = "List of worker pools"
}

variable "worker_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Optional, Map of lists containing node taints by node-pool name"
  default     = null
}

variable "ignore_worker_pool_size_changes" {
  type        = bool
  description = "Enable if using worker autoscaling. Stops Terraform managing worker count"
  default     = false
}

variable "ocp_version" {
  type        = string
  description = "The version of the OpenShift cluster that should be provisioned (format 4.x). This is only used during initial cluster provisioning, but ignored for future updates. Supports passing the string 'default' (current IKS default recommended version). If no value is passed, it will default to 'default'."
  default     = null
}

variable "cluster_ready_when" {
  type        = string
  description = "The cluster is ready when one of the following: MasterNodeReady (not recommended), OneWorkerNodeReady, Normal, IngressReady"
  default     = "IngressReady"
}

variable "ocp_entitlement" {
  type        = string
  description = "Value that is applied to the entitlements for OCP cluster provisioning"
  default     = "cloud_pak"
}

variable "force_delete_storage" {
  type        = bool
  description = "Flag indicating whether or not to delete attached storage when destroying the cluster - Default: false"
  default     = false
}
variable "existing_cos_id" {
  type        = string
  description = "The COS id of an already existing COS instance"
}

variable "kms_config" {
  type = object({
    crk_id           = string
    instance_id      = string
    private_endpoint = optional(bool, true) # defaults to true
    account_id       = optional(string)     # To attach HPCS instance from another account
  })
  description = "Use to attach a HPCS instance to the cluster. If account_id is not provided, defaults to the account in use."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC instance where this cluster will be provisioned"
}

variable "verify_worker_network_readiness" {
  type        = bool
  description = "By setting this to true, a script will run kubectl commands to verify that all worker nodes can communicate successfully with the master. If the runtime does not have access to the kube cluster to run kubectl commands, this should be set to false."
  default     = true
}

variable "addons" {
  type = object({
    debug-tool                = optional(string)
    image-key-synchronizer    = optional(string)
    openshift-data-foundation = optional(string)
    vpc-file-csi-driver       = optional(string)
    static-route              = optional(string)
    cluster-autoscaler        = optional(string)
    vpc-block-csi-driver      = optional(string)
  })
  description = "Map of OCP cluster add-on versions to install (NOTE: The 'vpc-block-csi-driver' add-on is installed by default for VPC clusters, however you can explicitly specify it here if you wish to choose a later version than the default one). For full list of all supported add-ons and versions, see https://cloud.ibm.com/docs/containers?topic=containers-supported-cluster-addon-versions"
  default     = null
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the resources created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details"
  default     = []
}

variable "cluster_config_endpoint_type" {
  description = "Specify which type of endpoint to use for for cluster config access: 'private', 'vpe', 'link'."
  type        = string
  default     = "private"
  nullable    = false # use default if null is passed in
  validation {
    error_message = "Invalid Endpoint Type! Valid values are 'default', 'private', 'vpe', or 'link'"
    condition     = contains(["private", "vpe", "link"], var.cluster_config_endpoint_type)
  }
}

##############################################################################
