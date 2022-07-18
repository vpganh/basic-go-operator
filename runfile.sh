//Step 1: Create a project

//Make a new directory, and init a project in it:
mkdir memcached-operator
cd memcached-operator
operator-sdk init --domain=example.com --repo=github.com/example/memcached-operator

go get sigs.k8s.io/controller-runtime@v0.12.1
go mod tidy //update go.mod
make


//Step 2: Create an API

//Generate a CRD and a controller
operator-sdk create api --group cache --version v1alpha1 --kind Memcached --resource=true --controller=true
make

//Edit the desired state and the observed state of Memcached
nano api/v1alpha1/memcached_types.go 
make generate
make manifests


//Step 3: Create a controller

nano controllers/memcached_controller.go //edit
make manifests

//Step 4: Build and deploy the operator

//Check if a valid config is available
kubectl config view

//Set up the Cloud If it has not been set up yet (must install Plug-in 'container-service 1.0.431' first)
ibmcloud login
//Added context for my cluster (which is 'mycluster-free') to the current kubeconfig file.
ibmcloud ks cluster config -c mycluster-free 
kubectl config current-context

//Check if the config file is changed yet
kubectl config view

//Build and push the Docker image
export USERNAME=vpganh //vpganh is my docker username
make docker-build docker-push IMG=docker.io/$USERNAME/memcached-operator:v1.0.0

//Deploy the operator
make deploy IMG=docker.io/$USERNAME/memcached-operator:v1.0.0 //This uses the manifests in config/ to create CRD, deploy controller in a Pod, create the RBAC roles needed for the controller to manage the CRD, and assign them to the controller
kubectl get crds //check the CRD
kubectl --namespace memcached-operator-system get deployments //Check the Deploument running the controller
kubectl --namespace memcached-operator-system get pods //Check the Pods running the controller
//check the RBAC
kubectl get clusterroles | grep memcached
kubectl get clusterrolebindings | grep memcached
kubectl --namespace memcached-operator-system get roles
kubectl --namespace memcached-operator-system get rolebindings

//Change the number of the nodes in the Memcached cluster
nano config/samples/cache_v1alpha1_memcached.yaml
kubectl apply -f config/samples/cache_v1alpha1_memcached.yaml // create a new instance of the custom resource

//View new custom resource and the objects being created in the background by the controller
kubectl get memcached
kubectl get deployments
kubectl get pods

//View the status updated with the name of the running node in the Memcached object
$ kubectl get memcached memcached-sample -o yaml
