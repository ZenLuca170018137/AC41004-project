# AC41004-project

### THE CONFIG FILE

To create a cluster to your preferences, open the config.yaml file.

The config file has a list of variables which you can edit. For example, if you wished to name your cluster "my_cluster" you would go to the cluster_name variable and change it to "my_cluster". Once this has been completed you can commit the changes to the main branch to start the pipeline.

### THE PIPELINE

After a commit on the main branch, a pipeline in GitHub Actions will automatically be triggered. This will initialise Terraform, validate it, and create a Terraform plan.

In order to apply Terraform changes, the user must manually trigger the workflow to do this in the GitHub Actions GUI.

The user can also Terraform destroy by triggering a separate pipeline in GitHub Actions.