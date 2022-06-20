// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:swarm_cloud_platform_interface/swarm_cloud_platform_interface.dart';
export 'package:swarm_cloud_platform_interface/swarm_cloud_platform_interface.dart'
    hide SwarmCloudPlatform;

class SwarmCloud {
  static SwarmCloudPlatform get _platform => SwarmCloudPlatform.instance;

  /// Create a new instance with token and the specified config.
  static Future<int> init(
    token, {
    required P2pConfig config,
    void Function(Map<String, dynamic>)? infoListener,
    SegmentIdGenerator? segmentIdGenerator,
  }) =>
      _platform.init(
        token,
        config: config,
        infoListener: infoListener,
        segmentIdGenerator: segmentIdGenerator,
      );

  /// Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
  static Future<String?> parseStreamURL(
    String sourceUrl, {
    String? videoId,
    Duration Function()? bufferedDurationGenerator,
  }) =>
      _platform.parseStreamURL(
        sourceUrl,
        videoId: videoId,
        bufferedDurationGenerator: bufferedDurationGenerator,
      );

  /// Get the connection state of p2p engine. 获取P2P Engine的连接状态
  static Future<bool> isConnected() => _platform.isConnected();

  /// Restart p2p engine.
  static Future<void> restartP2p() => _platform.restartP2p();

  /// Stop p2p and free used resources.
  static Future<void> stopP2p() => _platform.stopP2p();

  /// Get the peer ID of p2p engine. 获取P2P Engine的peer ID
  static Future<String> getPeerId() => _platform.getPeerId();
}
