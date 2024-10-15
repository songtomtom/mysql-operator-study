.PHONY: start setup install-operator install-cluster create-secret

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
	--set tls.useSelfSigned=true --values credentials.yaml

create-secret:
	kubectl create secret generic mypwds \
		--from-literal=rootUser=root \
		--from-literal=rootHost=% \
		--from-literal=rootPassword="sakila"