
az network public-ip create -n ingress_public_ip -g teamResources --allocation-method Static --sku Standard
az network vnet create -n vnet -g teamResources --address-prefix 10.2.0.0/22 --subnet-name 'ingress-subnet' --subnet-prefix 10.2.2.0/24
az network application-gateway create -n ingress_gateway -l ukwest -g teamResources --sku Standard_v2 --public-ip-address ingress_public_ip --vnet-name vnet --subnet 'ingress-subnet'
