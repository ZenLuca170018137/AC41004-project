//aws-eks-cluster resource to create EKS cluster

resource "aws_eks_cluster" "my-eks" {
  name     = var.cluster_name// cluster name
  role_arn = aws_iam_role.master.arn//ima role to be attatched to the cluster as it will be the master 
  //vpc config to determine the subnets to be attached to the cluster both public and private
 vpc_config {
    subnet_ids = [
      aws_subnet.public-1.id,
      aws_subnet.public-2.id,
      aws_subnet.private-1.id,
      aws_subnet.private-2.id
    ]
}
//cluster can not be created until its IAM policies abd the networking infrastructure has been completed.
  depends_on = [
aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
aws_vpc.vpc,
aws_subnet.public-1,
aws_subnet.public-2,
aws_subnet.private-1,
aws_subnet.private-2
  ]
  //tags for the cluster
  tags = {
    Name=var.cluster_name,
  }
}

/* output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
} */

//create a cloud watch log group to send logs to cloud watch abou the state of the cluster
resource "aws_cloudwatch_log_group" "eks_worker_nodes" {
  name              = "/aws/eks/worker-nodes"//log group name
  retention_in_days = 7// the logs will be retained in 7 days
  tags = {
    Name="${var.cluster_name}-eks_worker_nodes",
  }
}
//create a log stream in the log group
resource "aws_cloudwatch_log_stream" "eks_worker_nodes_stream" {
  name           = "worker-nodes-stream"
  log_group_name = aws_cloudwatch_log_group.eks_worker_nodes.name
  
}
// set up cloud watch alarms for the cluster when the cpu usage is above 80%
resource "aws_cloudwatch_metric_alarm" "eks_cpu_high" {
  alarm_name          = "eks-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "cpuUtilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"
  alarm_description   = "Alarm when EKS CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.eks_alarms.arn]
  dimensions = {
    ClusterName = aws_eks_cluster.my-eks.name
  }
}
// set up cloud watch alarms when the memory usage is above 80%
resource "aws_cloudwatch_metric_alarm" "eks_memory_high" {
  alarm_name          = "eks-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "memoryUtilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when EKS Memory exceeds 80%"
  alarm_actions       = [aws_sns_topic.eks_alarms.arn]
  dimensions = {
    ClusterName = aws_eks_cluster.my-eks.name
  }
}
//sns topic that the alarms can be associated with 
resource "aws_sns_topic" "eks_alarms" {
  name = "eks-alarms"
}
// the sns topic is attatched to a subscriber that can receive an email about the state of the cluster
resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.eks_alarms.arn
  
  protocol  = "email"
  endpoint  = "dev-test@gmail.com"
}

