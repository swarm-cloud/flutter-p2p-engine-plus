flutter create --template=plugin swarm_cloud

flutter create --template=plugin swarm_cloud_platform_interface

flutter create --template=plugin swarm_cloud_ios
flutter create -t plugin --platforms ios ./swarm_cloud_ios/

flutter create --template=plugin swarm_cloud_android
flutter create -t plugin --platforms android -a java ./swarm_cloud_android/

flutter create --template=plugin swarm_cloud_web
flutter create -t plugin --platforms web ./swarm_cloud_web/
