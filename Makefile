.PHONY: start setup install-operator install-cluster

start:
	minikube start --kubernetes-version=v1.30.0

setup: install-operator install-cluster

install-operator:
	helm repo add mysql-operator https://mysql.github.io/mysql-operator/
	helm repo update
	helm install my-mysql-operator mysql-operator/mysql-operator \
       --namespace mysql-operator --create-namespace

install-cluster:
	helm install mycluster mysql-operator/mysql-innodbcluster \
		--namespace mysql-cluster \
		--create-namespace \
		--set credentials.root.password='>-0URS4F3P4SS' \
		--set tls.useSelfSigned=true