# Đếm số lượng ReplicaSets trong tất cả các namespace mà không hiển thị tiêu đề
kubectl get rs --all-namespaces --no-headers | wc -l

# Liệt kê tất cả các Pods trong namespace hiện tại
kubectl get pods

# Liệt kê thông tin chi tiết của ReplicaSet có tên là 'new-replica-set' trong namespace hiện tại
kubectl get rs new-replica-set -o wide