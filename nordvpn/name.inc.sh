DOCKER_NAME='openvpn'
IMAGE_NAME='zhengkai/openvpn'

sudo docker stop $DOCKER_NAME 2>/dev/null
sudo docker rm $DOCKER_NAME 2>/dev/null
