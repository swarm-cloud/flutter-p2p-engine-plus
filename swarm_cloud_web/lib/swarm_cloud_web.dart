// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:swarm_cloud_platform_interface/swarm_cloud_platform_interface.dart';
import 'package:video_player_web_hls_swarm_cloud/hls.dart';
import 'package:video_player_web_hls_swarm_cloud/swarm_cloud_video_player_hls.dart';

class SwarmCloudWeb extends SwarmCloudPlatform {
  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith(Registrar registrar) {
    SwarmCloudPlatform.instance = SwarmCloudWeb();
  }

  /// Create a new instance with token and the specified config.
  @override
  Future<int> init(
    token, {
    required P2pConfig config,
    CdnByeInfoListener? infoListener,
    SegmentIdGenerator? segmentIdGenerator,
  }) async {
    SwarmVideoPlayerPluginHls.hlsConfigBuilder = (headers) {
      var hlsConfig = HlsConfig(
        xhrSetup: allowInterop(
          (HttpRequest xhr, String _) {
            if (headers.isEmpty) return;
            if (headers.containsKey('useCookies')) xhr.withCredentials = true;
            headers.forEach((String key, String value) {
              if (key != 'useCookies') xhr.setRequestHeader(key, value);
            });
          },
        ),
      );
      hlsConfig.token = token;
      hlsConfig.logLevel =
          ["none", "debug", "info", "warn", "error"][config.logLevel.index];
      hlsConfig.webRTCConfig = config.webRTCConfig;
      hlsConfig.announce = config.announce;
      hlsConfig.memoryCacheLimit = config.memoryCacheLimit;
      hlsConfig.p2pEnabled = config.p2pEnabled;
      hlsConfig.useHttpRange = config.useHttpRange;
      hlsConfig.httpLoadTime = config.httpLoadTime;
      hlsConfig.sharePlaylist = config.sharePlaylist;

      // TODO: infoListener
      // hlsConfig.sharePlaylist = config.sharePlaylist;
      
      // TODO: segmentIdGenerator
      // hlsConfig.sharePlaylist = config.sharePlaylist;

      return hlsConfig;
    };
    return 0;
  }

  /// Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
  @override
  Future<String?> parseStreamURL(
    String sourceUrl, [
    String? videoId,
  ]) async {
    return sourceUrl;
  }

  /// Get the connection state of p2p engine. 获取P2P Engine的连接状态
  @override
  Future<bool> isConnected() async {
    return true;
  }

  /// Restart p2p engine.
  @override
  Future<void> restartP2p() async {
    // return false;
  }

  /// Stop p2p and free used resources.
  @override
  Future<void> stopP2p() async {
    // return false;
  }

  /// Get the peer ID of p2p engine. 获取P2P Engine的peer ID
  @override
  Future<String> getPeerId() async {
    return '';
  }
}
