import yaml
import requests
import urllib3
import json

from yaml.loader import SafeLoader

with open("config.yaml", "r") as ymlfile:
    vari = yaml.load(ymlfile, Loader=SafeLoader)

urllib3.disable_warnings()
headers_kibana = {'content-type': 'application/json', 'kbn-xsrf': 'true', 'Accept-Charset': 'UTF-8'}
headers_elastic = {'content-type': 'application/json', 'Accept-Charset': 'UTF-8'}
elk_basic_url = f"{vari['elastic_authen']['scheme']}://{vari['elastic_authen']['host']}:{vari['elastic_authen']['port']}/"

# parser = argparse.ArgumentParser(description="Option to interact with Elastic Stack")
# parser.add_argument("-o", "--option", type=int, help="Choise ")
# args = parser.parse_args()


def json_view(value):
    print(json.loads(value))


def string_view(value):
    print(value.decode("UTF-8"))


def show_license_type():
    response = requests.get(f"{elk_basic_url}_license?accept_enterprise=true" ,auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"), headers=headers_elastic, verify=False)
    return response.content


def show_node_allocation():
    response = requests.get(f"{elk_basic_url}_cat/allocation?pretty" ,auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"), headers=headers_elastic, verify=False)
    return response.content


def change_replicas(index, num_of_replica):
    data = f'{{"index": {{"number_of_replicas": {num_of_replica}}}}}'
    response = requests.put(f"{elk_basic_url}{index}/_settings",
                            auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"),
                            headers=headers_elastic, verify=False, data=data)
    return response.content


def open_index(index):
    response = requests.post(f"{elk_basic_url}{index}/_open?pretty",
                            auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"),
                            headers=headers_elastic, verify=False)
    return response.content


def close_index(index):
    response = requests.post(f"{elk_basic_url}{index}/_close?pretty",
                            auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"),
                            headers=headers_elastic, verify=False)
    return response.content


def freeze_index(index):
    response = requests.post(f"{elk_basic_url}{index}/_freeze?pretty",
                            auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"),
                            headers=headers_elastic, verify=False)
    return response.content


def unfreeze_index(index):
    response = requests.post(f"{elk_basic_url}{index}/_unfreeze?pretty",
                            auth=(f"{vari['elastic_authen']['user']}", f"{vari['elastic_authen']['password']}"),
                            headers=headers_elastic, verify=False)
    return response.content



def main():
    print("1, Show license type")
    print("2, Show data node info")
    print("3, Change number of replica")
    print("4, Open indices")
    print("5, Close indices")
    print("6, Freeze indices")
    print("7, UnFreeze indices")
    print(", ")
    option = int(input("Enter your option: "))
    if option == 1:
        json_view(show_license_type())
    elif option == 2:
        string_view(show_node_allocation())
    elif option == 3:
        index = input("Indices name: ")
        num_of_replica = int(input("Number of replicas: "))
        json_view(change_replicas(index, num_of_replica))
    elif option == 4:
        index = input("Indices name: ")
        json_view(open_index(index))
    elif option == 5:
        index = input("Indices name: ")
        json_view(close_index(index))
    elif option == 6:
        index = input("Indices name: ")
        json_view(freeze_index(index))
    elif option == 7:
        index = input("Indices name: ")
        json_view(unfreeze_index(index))

if __name__ == "__main__":
    main()