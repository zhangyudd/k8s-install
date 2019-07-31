#!/bin/bash
# 将kubetnetes集群从1.13 升级到 1.14
yum install -y kubeadm-1.14.0 kubectl-1.14.0 kubelet-1.14.0

kubeadm config images list
#k8s.gcr.io/kube-apiserver:v1.14.0
#k8s.gcr.io/kube-controller-manager:v1.14.0
#k8s.gcr.io/kube-scheduler:v1.14.0
#k8s.gcr.io/kube-proxy:v1.14.0
#k8s.gcr.io/pause:3.1
#k8s.gcr.io/etcd:3.3.10
#k8s.gcr.io/coredns:1.3.1

# 由于我在1.13.0版本时，已经有了这个repo，所以没有执行，大家想用的可以自取
# yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

## 拉取镜像
docker pull registry.cn-beijing.aliyuncs.com/kube-zy/kube-apiserver:v1.14.0
docker pull registry.cn-beijing.aliyuncs.com/kube-zy/kube-controller-manager:v1.14.0
docker pull registry.cn-beijing.aliyuncs.com/kube-zy/kube-scheduler:v1.14.0
docker pull registry.cn-beijing.aliyuncs.com/kube-zy/kube-proxy:v1.14.0
docker pull registry.cn-beijing.aliyuncs.com/kube-zy/etcd:3.3.10
docker pull registry.cn-beijing.aliyuncs.com/kube-zy/pause:3.1
docker pull registry.cn-beijing.aliyuncs.com/coredns:1.3.1


## 添加Tag
docker tag registry.cn-beijing.aliyuncs.com/kube-zykube-apiserver:v1.14.0 k8s.gcr.io/kube-apiserver:v1.14.0
docker tag registry.cn-beijing.aliyuncs.com/kube-zykube-scheduler:v1.14.0 k8s.gcr.io/kube-scheduler:v1.14.0
docker tag registry.cn-beijing.aliyuncs.com/kube-zykube-controller-manager:v1.14.0 k8s.gcr.io/kube-controller-manager:v1.14.0
docker tag registry.cn-beijing.aliyuncs.com/kube-zykube-proxy:v1.14.0 k8s.gcr.io/kube-proxy:v1.14.0
docker tag registry.cn-beijing.aliyuncs.com/kube-zyetcd:3.3.10 k8s.gcr.io/etcd:3.3.10
docker tag registry.cn-beijing.aliyuncs.com/kube-zypause:3.1 k8s.gcr.io/pause:3.1
docker tag registry.cn-beijing.aliyuncs.com/coredns:1.3.1 k8s.gcr.io/coredns:1.3.1

# 移除
docker rmi registry.cn-beijing.aliyuncs.com/kube-zy/kube-apiserver:v1.14.0
docker rmi registry.cn-beijing.aliyuncs.com/kube-zy/kube-controller-manager:v1.14.0
docker rmi registry.cn-beijing.aliyuncs.com/kube-zy/kube-scheduler:v1.14.0
docker rmi registry.cn-beijing.aliyuncs.com/kube-zy/kube-proxy:v1.14.0
docker rmi registry.cn-beijing.aliyuncs.com/kube-zy/pause:3.1
docker rmi registry.cn-beijing.aliyuncs.com/kube-zy/etcd:3.3.10
docker rmi registry.cn-beijing.aliyuncs.com/coredns:1.3.1

# worker节点不需要执行    主节点执行，看到下面信息，表示升级OK了。
kubeadm upgrade apply v1.14.0
# [upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.14.0". Enjoy!

# master 和 worker最后都需要重启下kubectl
systemctl daemon-reload
systemctl restart kubelet

# 查看下worker 和 master的Version  ，是否为1.14.0
kubectl get nodes
#NAME       STATUS   ROLES    AGE   VERSION
#master01   Ready    master   15d   v1.14.0
#slave01    Ready    worker     15d   v1.14.0
#slave02    Ready    worker     13d   v1.14.0
