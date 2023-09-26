resource "aws_elb" "aws_load_balancer" {
    name="terraform-elb"
    subnets=[
        aws_subnet.private-us-east-1a.id,
        aws_subnet.private-us-east-1b.id
    ]
   
    access_logs {
        bucket="terraform-elb-logs"
        bucket_prefix="terraform-elb"
        interval=5
    }
    health_check {
        healthy_threshold=2
        unhealthy_threshold=2
        timeout=3
        target="HTTP:80/"
        interval=30
    }
    listener {
        instance_port=80
        instance_protocol="HTTP"
        lb_port=80
        lb_protocol="HTTP"
    }
//instances
     instances                   = [
        aws_instance.test-node.id
     ]
   
    idle_timeout = 400
    cross_zone_load_balancing=true
    connection_draining=true
    connection_draining_timeout=400  

    tags={
        Name="terraform-elb"
    }

}

