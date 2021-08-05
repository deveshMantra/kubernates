kubectl apply -f ../secret/mongodb_secrets.yaml
kubectl apply -f mongodb_deployment.yaml
kubectl apply -f mongodb_service.yaml
# commenting as now we dont need node port for it
# kubectl apply -f mongo_db_service_nodeport.yaml