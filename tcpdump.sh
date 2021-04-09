#!/usr/bin/env bash
namespace="myapp-prod"
prod_name_prefix="myapp-service-prod"
pods=`kubectl get pods -n $namespace --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep $prod_name_prefix`
mv /tmp/tshark-output /tmp/tshark-output-$(date +%F_%R)
for pod_name in $pods
do
  echo "Atatching sniffer to $pod_name...."
  mkdir -p /tmp/tshark-output/"$pod_name"
  nohup kubectl sniff "$pod_name" -n "$namespace" -p -o - | tshark -F pcapng -w - > /tmp/tshark-output/"$pod_name"/tshark.out 2> /tmp/tshark-output/"$pod_name"/tshark.err &
  echo "Staretd sniffer for pod $pod_name...."
done
echo "Done...logging dump traffic to /tmp/tshark-output "
