import yaml

def fileHandling(filename, variables):

    with open(f'{filename}.yaml','r') as f:
        output = yaml.safe_load(f)
    #print(output["private_subnets"][1])
    #print(output["namespaces"][0])
    #print(output["ingress_HTTPS"]["from_port"])

            
    with open(variables, 'r', encoding='utf-8') as file:
        data = file.readlines()
    data[4] = '  default = "' + output["region"] + '"' + '\n'


    data[9] = '  default = "' + output["cluster_name"] + '"' + '\n'


    data[20] = '      cidr_block        = "' + output["private_subnets"][0] + '"' + '\n'
    data[21] = '      availability_zone = "' + output["private_subnets"][1] + '"' + '\n'
    data[24] = '      cidr_block        = "' + output["private_subnets"][2] + '"' + '\n'
    data[25] = '      availability_zone = "' + output["private_subnets"][3] + '"' + '\n'
    data[28] = '      cidr_block        = "' + output["private_subnets"][4] + '"' + '\n'
    data[29] = '      availability_zone = "' + output["private_subnets"][5] + '"' + '\n'
    data[32] = '      cidr_block        = "' + output["private_subnets"][6] + '"' + '\n'
    data[33] = '      availability_zone = "' + output["private_subnets"][7] + '"' + '\n'


    data[40] = '  default = ["' + output["namespaces"][0] + '"]' + '\n'


    data[53] = '      from_port   = ' + str(output["ingress_HTTPS"]["from_port"])  + '\n'
    data[54] = '      to_port     = ' + str(output["ingress_HTTPS"]["to_port"]) + '\n'
    data[55] = '      protocol    = "' + output["ingress_HTTPS"]["protocol"] + '"' + '\n'

    data[59] = '      from_port   = ' + str(output["ingress_HTTP"]["from_port"])  + '\n'
    data[60] = '      to_port     = ' + str(output["ingress_HTTP"]["to_port"]) + '\n'
    data[61] = '      protocol    = "' + output["ingress_HTTP"]["protocol"] + '"' + '\n'

    data[65] = '      from_port   = ' + str(output["ingress_custom"]["from_port"])  + '\n'
    data[66] = '      to_port     = ' + str(output["ingress_custom"]["to_port"]) + '\n'
    data[67] = '      protocol    = "' + output["ingress_custom"]["protocol"] + '"' + '\n'


    data[81] = '    desired_size   = ' + str(output["capacity"]["desired_size"]) + '\n'
    data[82] = '    min_size       = ' + str(output["capacity"]["min_size"]) + '\n'
    data[83] = '    max_size       = ' + str(output["capacity"]["max_size"]) + '\n'
    data[84] = '    instance_types = ["' + str(output["capacity"]["instance_types"][0]) + '"]' + '\n'
    data[85] = '    capacity_type  = "' + output["capacity"]["capacity_type"] + '"'+ '\n'


    with open(variables, 'w', encoding='utf-8') as file:
        file.writelines(data)
    
fileHandling('config','variables.tf')