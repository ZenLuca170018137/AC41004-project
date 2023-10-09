#PyYAML library to import YAML files
import yaml

#Function to input changes form YAML file into variables.tf
#Inputs: 
#filename - the YAML file
#variables - the variables.tf file
def fileHandling(filename, variables):

    #Open and read the YAML file with the user inputs
    with open(f'{filename}.yaml','r') as f:
        output = yaml.safe_load(f)

    #Open and read the variables file to output the user inputs        
    with open(variables, 'r', encoding='utf-8') as file:
        data = file.readlines()

    #Change all the field in the variables.tf file
    #Region
    data[4] = '  default = "' + output["region"] + '"' + '\n'

    #cluster name
    data[9] = '  default = "' + output["cluster_name"] + '"' + '\n'

    #4 different sets of subnets with their cidr_block (IP) and what zone they work on
    #Subnet 1
    data[20] = '      cidr_block        = "' + output["private_subnets"][0] + '"' + '\n'
    data[21] = '      availability_zone = "' + output["private_subnets"][1] + '"' + '\n'

    #Subnet 2
    data[24] = '      cidr_block        = "' + output["private_subnets"][2] + '"' + '\n'
    data[25] = '      availability_zone = "' + output["private_subnets"][3] + '"' + '\n'

    #Subnet 3
    data[28] = '      cidr_block        = "' + output["private_subnets"][4] + '"' + '\n'
    data[29] = '      availability_zone = "' + output["private_subnets"][5] + '"' + '\n'

    #Subnet 4
    data[32] = '      cidr_block        = "' + output["private_subnets"][6] + '"' + '\n'
    data[33] = '      availability_zone = "' + output["private_subnets"][7] + '"' + '\n'

    #namespace
    data[40] = '  default = ["' + output["namespaces"][0] + '"]' + '\n'

    #3 different sets for Ingress controller with destination port and initial port and what protocol to use
    #Ingrees set 1
    data[50] = '      from_port   = ' + str(output["ingress_HTTPS"]["from_port"])  + '\n'
    data[51] = '      to_port     = ' + str(output["ingress_HTTPS"]["to_port"]) + '\n'
    data[52] = '      protocol    = "' + output["ingress_HTTPS"]["protocol"] + '"' + '\n'

    #Ingress set 2
    data[63] = '      from_port   = ' + str(output["ingress_HTTP"]["from_port"])  + '\n'
    data[64] = '      to_port     = ' + str(output["ingress_HTTP"]["to_port"]) + '\n'
    data[65] = '      protocol    = "' + output["ingress_HTTP"]["protocol"] + '"' + '\n'

    #Ingress set 3
    data[76] = '      from_port   = ' + str(output["ingress_custom"]["from_port"])  + '\n'
    data[77] = '      to_port     = ' + str(output["ingress_custom"]["to_port"]) + '\n'
    data[78] = '      protocol    = "' + output["ingress_custom"]["protocol"] + '"' + '\n'

    #Cluster size
    data[91] = '    desired_size   = ' + str(output["capacity"]["desired_size"]) + '\n'
    data[92] = '    min_size       = ' + str(output["capacity"]["min_size"]) + '\n'
    data[93] = '    max_size       = ' + str(output["capacity"]["max_size"]) + '\n'
    data[94] = '    instance_types = ["' + str(output["capacity"]["instance_types"][0]) + '"]' + '\n'
    data[95] = '    capacity_type  = "' + output["capacity"]["capacity_type"] + '"'+ '\n'

    #Write into the variables.tf file in order to apply all the changes
    with open(variables, 'w', encoding='utf-8') as file:
        file.writelines(data)

#Run the function above
fileHandling('config','variables.tf')