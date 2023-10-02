import yaml

def fileHandling(filename, variables):

    with open(f'{filename}.yaml','r') as f:
        output = yaml.safe_load(f)
    print(output["region"])

            
    with open(variables, 'r', encoding='utf-8') as file:
        data = file.readlines()
    data[4] = '  default = "' + output["region"] + '"' + '\n'
    with open(variables, 'w', encoding='utf-8') as file:
        file.writelines(data)
    
fileHandling('config','variables.tf')