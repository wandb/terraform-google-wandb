// deployment for the nfs service

resource "kubernetes_service" "nfs-server" {
    metadata {
      name = "nfs-server"
    }
    spec {
        selector = {
          app = kubernetes_deployment.nfs-server.metadata[0].labels.app
        }
        port {
          port        = 2049
          target_port = 2049
        }
    }
}

resource "kubernetes_deployment" "nfs-server" {
    metadata {
        name = "nfs-server"
        labels = {
        app = "nfs-server"
        }
    }
    spec {
        replicas = 1
        selector {
        match_labels = {
            app = "nfs-server"
        }
        }
        template {
        metadata {
            labels = {
            app = "nfs-server"
            }
        }
        spec {
            container {
                image = "k8s.gcr.io/volume-nfs:0.8"
                name = "nfs-server"
                port {
                    container_port = 2049
                    name = "nfs"
                }
                port {
                    container_port = 20048
                    name = "mountd"
                }
                port {
                    container_port = 111
                    name = "rpcbind"
                }
                security_context {
                    privileged = true
                }
                volume_mount {
                    mount_path = "/exports"
                    name = "nfs-pvc"
                }
            }
            volume {
                name = "nfs-pvc"
                persistent_volume_claim {
                    claim_name = "nfs-pvc"
                }
            }
        }
        }
    }
}


resource "kubernetes_persistent_volume_claim" "nfs-pvc" {
    metadata {
        name = "nfs-pvc"
    }
    spec {
        access_modes = ["ReadWriteOnce"]
        storage_class_name = ""    # rwo is default
        resources {
        requests = {
            storage = "1Gi"
        }
        }
    }
}

resource "kubernetes_persistent_volume" "nfs-pv" {
    metadata {
        name = "nfs-pv"
    }
    spec {
        access_modes = ["ReadWriteOnce"]
        capacity = {
            storage = "1Gi"
        }
        persistent_volume_reclaim_policy = "Retain"
        storage_class_name = ""
        persistent_volume_source {
          nfs {
            path = "/exports"
            server = "nfs-server.default.svc.cluster.local"
          }
        }
    }
}