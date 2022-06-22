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
    void Function(Map<String, dynamic>)? infoListener,
    SegmentIdGenerator? segmentIdGenerator, // 给SDK提供segmentId
    bool bufferedDurationGeneratorEnable = false, // 是否可以给SDK提供缓冲前沿到当前播放时间的差值
  }) async {
    SwarmVideoPlayerPluginHls.hlsConfigBuilder = (headers) {
      var p2pConfig = P2PSettingConfig(
        getStats: infoListener == null
            ? null
            : allowInterop(
                (
                  totalP2PDownloaded,
                  totalP2PUploaded,
                  totalHTTPDownloaded,
                  p2pDownloadSpeed,
                ) {
                  var data = {
                    "totalHTTPDownloaded": totalHTTPDownloaded,
                    "totalP2PDownloaded": totalP2PDownloaded,
                    "totalP2PUploaded": totalP2PUploaded,
                    "p2pDownloadSpeed": p2pDownloadSpeed,
                  };
                  infoListener.call(data);
                },
              ),
        segmentId: segmentIdGenerator == null
            ? null
            : allowInterop((
                String streamId,
                int sn,
                String segmentUrl,
                String? range,
              ) {
                return segmentIdGenerator.call(
                  streamId,
                  sn,
                  segmentUrl,
                  range,
                );
              }),
      );
      p2pConfig.token = token;
      p2pConfig.logLevel =
          ["none", "debug", "info", "warn", "error"][config.logLevel.index];
      p2pConfig.webRTCConfig = config.webRTCConfig;
      p2pConfig.announce = config.announce;
      p2pConfig.memoryCacheLimit = config.memoryCacheLimit;
      p2pConfig.p2pEnabled = config.p2pEnabled;
      p2pConfig.useHttpRange = config.useHttpRange;
      p2pConfig.httpLoadTime = config.httpLoadTime;
      p2pConfig.sharePlaylist = config.sharePlaylist;

      var hlsConfig = P2PHlsConfig(
        xhrSetup: allowInterop(
          (HttpRequest xhr, String _) {
            if (headers.isEmpty) return;
            if (headers.containsKey('useCookies')) xhr.withCredentials = true;
            headers.forEach((String key, String value) {
              if (key != 'useCookies') xhr.setRequestHeader(key, value);
            });
            config.httpHeaders?.forEach((key, value) {
              xhr.setRequestHeader(key, value);
            });
          },
        ),
        p2pConfig: p2pConfig,
      );
      return hlsConfig;
    };
    return 0;
  }

  /// Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
  @override
  Future<String?> parseStreamURL(
    String sourceUrl, {
    String? videoId,
    Duration Function()? bufferedDurationGenerator,
  }) async {
    // print('web parse');
    if (bufferedDurationGenerator != null) {
      throw 'bufferedDurationGenerator not avaliable on web platform';
    }
    return sourceUrl;
  }

  /// Get the connection state of p2p engine. 获取P2P Engine的连接状态
  // @override
  // Future<bool> isConnected() async {
  //   return true;
  // }

  /// Restart p2p engine.
  @override
  Future<void> restartP2p() async {
    hls?.p2pEngine.disableP2P();
    hls?.p2pEngine.enableP2P();
  }

  /// Stop p2p and free used resources.
  @override
  Future<void> stopP2p() async {
    hls?.p2pEngine.disableP2P();
  }

  /// Get the peer ID of p2p engine. 获取P2P Engine的peer ID
  @override
  Future<String> getPeerId() async {
    throw 'getPeerId not avaliable on web platform';
  }
}
