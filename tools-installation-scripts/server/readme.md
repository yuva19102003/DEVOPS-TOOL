🔧 Easy version change

Just edit at top:

NODE_VERSION="20"
GO_VERSION="1.22.2"


Re-run → done.

If you want next:

I can give you a non-interactive argument-based version,
so you can run:

./server-setup.sh all


or

./server-setup.sh docker nginx golang


Perfect for cloud-init, Terraform, or GitHub Actions runners.