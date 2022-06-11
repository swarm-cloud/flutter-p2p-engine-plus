export http_proxy="http://127.0.0.1:8001";
export HTTP_PROXY="http://127.0.0.1:8001";
export https_proxy="http://127.0.0.1:8001";
export HTTPS_PROXY="http://127.0.0.1:8001"

flutter pub publish -C ./swarm_cloud_video_player_hls_fork

flutter pub publish -C ./swarm_cloud_platform_interface

flutter pub publish -C ./swarm_cloud_web

flutter pub publish -C ./swarm_cloud

