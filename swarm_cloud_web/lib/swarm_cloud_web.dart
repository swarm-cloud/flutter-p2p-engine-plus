// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:safemap/safemap.dart';
import 'package:swarm_cloud_platform_interface/swarm_cloud_platform_interface.dart';

class SwarmCloudWeb extends SwarmCloudPlatform {
  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith() {
    SwarmCloudPlatform.instance = SwarmCloudWeb();
  }

  /// Create a new instance with token and the specified config.
  Future<int> init(
    token, {
    required P2pConfig config,
    CdnByeInfoListener? infoListener,
    SegmentIdGenerator? segmentIdGenerator,
  }) async {
    return 0;
  }

  /// Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
  Future<String?> parseStreamURL(
    String sourceUrl, [
    String? videoId,
  ]) async {
    return sourceUrl;
  }

  /// Get the connection state of p2p engine. 获取P2P Engine的连接状态
  @override
  Future<bool> isConnected() async {
    return false;
  }

  /// Restart p2p engine.
  Future<void> restartP2p() async {
    // return false;
  }

  /// Stop p2p and free used resources.
  Future<void> stopP2p() async {
    // return false;
  }

  /// Get the peer ID of p2p engine. 获取P2P Engine的peer ID
  Future<String> getPeerId() async {
    return '';
  }
}
