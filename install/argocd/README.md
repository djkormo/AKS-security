```bash
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

```
kubectl get pods -n  argocd
```
<pre>
NAME                                            READY   STATUS    RESTARTS   AGE
argocd-application-controller-d99d77688-c48xh   1/1     Running   0          17m
argocd-dex-server-6c865df778-wgwpc              1/1     Running   0          17m
argocd-redis-8c568b5db-7hdhs                    1/1     Running   0          17m
argocd-repo-server-675bddcbb8-j85f9             1/1     Running   0          17m
argocd-server-75877b6ffb-wd9tv                  1/1     Running   0          17m
</pre>

```
kubectl get svc -n  argocd
```
<pre>
NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
argocd-dex-server       ClusterIP   10.0.208.98    <none>        5556/TCP,5557/TCP,5558/TCP   17m
argocd-metrics          ClusterIP   10.0.192.224   <none>        8082/TCP                     17m
argocd-redis            ClusterIP   10.0.11.181    <none>        6379/TCP                     17m
argocd-repo-server      ClusterIP   10.0.17.252    <none>        8081/TCP,8084/TCP            17m
argocd-server           ClusterIP   10.0.223.18    <none>        80/TCP,443/TCP               17m
argocd-server-metrics   ClusterIP   10.0.246.137   <none>        8083/TCP                     17m
</pre>

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

https://localhost:8080

```bash
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
```
```
kubectl apply -f argocd-ingress.yaml -n argocd
```
<pre>
ingress.extensions/argocd-server-ingress created
</pre>


Browse at

kube

argocd login localhost:8080

argocd account update-password



    # Create a directory app
    argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse

    # Create a Jsonnet app
    argocd app create jsonnet-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path jsonnet-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --jsonnet-ext-str replicas=2

    # Create a Helm app
    argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --helm-set replicaCount=2

    # Create a Helm app from a Helm repo
    argocd app create nginx-ingress --repo https://kubernetes-charts.storage.googleapis.com --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc

    # Create a Kustomize app
    argocd app create kustomize-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path kustomize-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --kustomize-image gcr.io/heptio-images/ks-guestbook-demo=0.1    

    # Create a app using a custom tool:
    argocd app create ksane --repo https://github.com/argoproj/argocd-example-apps.git --path plugins/kasane --dest-namespace default --dest-server https://kubernetes.default.svc --config-management-plugin kasane


argocd app create realtime --repo https://github.com/gbaeke/argo-demo.git --path manifests \
--dest-server https://kubernetes.default.svc --dest-namespace default


export MY_APP_NAME=express-app
export MY_REPO_NAME=https://github.com/Dizdarevic/gitops-brown-bag.gitexport 
export MY_DEPLOYMENT_PATH=example-app/deployment-repo
argocd app create $MY_APP_NAME --repo $MY_REPO_NAME --path $MY_DEPLOYMENT_PATH  \
  --dest-server https://kubernetes.default.svc --dest-namespace default

Literature:

https://blog.baeke.info/2019/12/25/giving-argo-cd-a-spin/

https://dev.to/dizveloper/gitops-w-argocd-a-tutorial-7o4


https://medium.com/@alexsimonjones/bootstrapping-kubernetes-with-argocd-989f27ae475


