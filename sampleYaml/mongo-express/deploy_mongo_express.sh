# deploy first config map as we are referring to it in deployment
kubectl apply -f mongo_express_deployment.yaml
# kubectl apply -f nodeapp_service.yaml
# kubectl apply -f nodeapp_service_node_port.yaml