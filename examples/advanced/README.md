# Advanced example (mzr, auto-scale, kms, taints)

An advanced example that demonstrates how to create a multi-zone KMS encrypted OCP VPC cluster with custom worker node taints.

The following resources are provisioned by this example:

The following resources are created:
- A new resource group if an existing one is not provided.
- A Key Protect instance with two root keys: one for encrypting the cluster and one for encrypting worker block storage.
- A VPC with subnets across three availability zones.
- A public gateway only in zone 1.
- A multi-zone (three-zone) KMS-encrypted OCP VPC cluster with worker pools in each zone.
- Auto-scaling is enabled for the default worker pool.
- Taints are applied to the workers in zone 2 and zone 3.
