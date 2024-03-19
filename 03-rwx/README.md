# 03-rwx - classe de stockage RWX avec NFS managé

## Principe

[main.tf](main.tf) assure :

* La création d'une instance de serveur NFS avec le module [nfs-server](../modules/nfs-server/README.md)
* La mise à disposition de celle-ci sous forme d'une classe de stockage ReadWriteMany à l'aide de "nfs-subdir-external-provisioner"

## Exemple d'utilisation

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: demo-rwx-pvc
spec:
  accessModes:
    - ReadWriteMany
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5Gi
  storageClassName: nfs-legacy
```
