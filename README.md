#  Using Operator SDK to scaffold a basic Go Memcached operator

## Objectives
 - Create a new project and add to the API by creating a Custom Resource Definition (CRD) and a basic controller.
 - Add fields to the CRD to contain some information about the desired and actual state, modify the controller to reconcile instances of new resource, and then deploy the operator to Kubernetes cluster.

##Prerequisites
- Operator-sdk v1.5.0+ installed
- Kubectl v1.17.0+ installed
- Admin access to a Kubernetes cluster. See earlier in the course for instructions on how to deploy a small cluster for free on IBM Cloud.
- Docker v3.2.2+ installed
- Access to a Docker image repository such as Docker Hub or quay.io
- Golang v1.16.0+ installed
