# Mongodb Compass client installation steps

* setup: we should be on ubuntu desktop (or vm) where minikube is running.

### Installation
Install mongodb compass from here: https://www.mongodb.com/try/download/compass

### Check the health of mongodb pod whether it is running fine and accepting requests. This should print the port 27017 (as configured in mongo-pod yaml):
```
kubectl get pod mongodb-64685c6576-9t4lc -n mfpocns --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'
```

### Next port-forward so that we can connect compass can connect to mongodb pod:
```
kubectl port-forward mongodb-64685c6576-9t4lc -n mfpocns 28017:27017
```

### Connect to mongo-pod from Compass UI.
use the following connection string in Compass and connect:
```
mongodb://mongo:mongo@localhost:28017/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false
```

There after you should be able to browse/create/edit the data in mongodb compass.

### Also if we want to connect to mongo shell, then we can do so as this:
```
exec pod/mongodb-64685c6576-9t4lc -n mfpocns -it -- bash
mongosh --username mongo --password mongo --authenticationDatabase admin
```

The data is persisted in vmnfs and remains intacts even after pods are replaced due to cluster restarts.

