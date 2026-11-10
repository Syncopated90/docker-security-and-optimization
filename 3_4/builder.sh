#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: ./builder.sh <github-repo> <docker-repo>"
  exit 1
fi 
REPO_URL="https://github.com/${1}"
IMAGE_NAME="${2}"

WORK_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

for cmd in git docker; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# Check Docker availability
if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker daemon is not running or accessible."
    exit 1
fi

git clone --depth 1 "$REPO_URL" "$WORK_DIR/repo"

# Verify Dockerfile
if [[ ! -f "$WORK_DIR/repo/Dockerfile" ]]; then
    echo "Error: No Dockerfile found in repository root."
    exit 1
fi
# Build Docker image
echo "[2/3] Building Docker image..."

docker build \
    --pull \
    -t "${IMAGE_NAME}" \
    "$WORK_DIR/repo"

# Display result
echo "[3/3] Build completed!"

echo
echo "Docker image created successfully:"
docker images "${IMAGE_NAME}"


#login
echo "======================================"
echo " Build and push completed!"
echo " logging in with $DOCKER_USERNAME and $DOCKER_PASSWORD"
echo "======================================"
docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD"
# Push image
echo "[4/4] Pushing image to Docker Hub..."
docker image tag "$IMAGE_NAME" "$IMAGE_NAME"
docker push "$IMAGE_NAME"

echo
echo "======================================"
echo " Build and push completed!"
echo "======================================"

echo
echo "Run your container with:"
echo "docker run --rm -it ${IMAGE_NAME}"
