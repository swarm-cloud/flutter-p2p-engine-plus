import 'package:flutter/services.dart';
import 'package:safemap/safemap.dart';
import 'package:swarm_cloud_platform_interface/swarm_cloud_platform_interface.dart';

class SwarmCloudChannel extends SwarmCloudPlatform {
  static const MethodChannel _channel = const MethodChannel('cdnbye');

  /// The version of SDK.
  /// SDK的版本号
  static Future<String> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version ?? 'Unknown Version';
  }

  static Duration Function()? _bufferedDurationGenerator;

  static bool _bufferedDurationGeneratorEnable = false;

  /// Create a new instance with token and the specified config.
  Future<int> init(
    token, {
    required P2pConfig config,
    CdnByeInfoListener? infoListener,
    SegmentIdGenerator? segmentIdGenerator, // 给SDK提供segmentId
    bool bufferedDurationGeneratorEnable = false, // 是否可以给SDK提供缓冲前沿到当前播放时间的差值
  }) async {
    _bufferedDurationGeneratorEnable = bufferedDurationGeneratorEnable;
    final int? success = await _channel.invokeMethod('init', {
      'token': token,
      'config': config.toMap,
      'enableSegmentIdGenerator': segmentIdGenerator != null,
      'enableBufferedDurationGenerator': bufferedDurationGeneratorEnable,
    });
    if (infoListener != null) {
      await _channel.invokeMethod('startListen');
    }

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'info') {
        var map = Map<String, dynamic>.from(call.arguments);
        infoListener?.call(map);
      } else if (call.method == 'segmentId') {
        /// SegmentIdGenerator
        var data = SafeMap(call.arguments);
        return {
          'result': (segmentIdGenerator ?? defaultSegmentIdGenerator).call(
                data['streamId'].string ?? "",
                data['sn'].intValue ?? 0,
                data['segmentUrl'].string ?? "",
                data['range'].string,
              ) ??
              call.arguments['url'],
        };
      } else if (call.method == 'bufferedDuration') {
        var duration = _bufferedDurationGenerator?.call();
        return {'result': duration?.inSeconds ?? -1};
      }
      return {"success": true};
    });

    if (success == null) {
      throw 'Not Avaliable Result: $success. Init fail.';
    }
    return success;
  }

  /// Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
  Future<String?> parseStreamURL(
    String sourceUrl, {
    String? videoId,
    Duration Function()? bufferedDurationGenerator,
  }) async {
    if (_bufferedDurationGeneratorEnable && bufferedDurationGenerator == null) {
      throw 'Must provide bufferedDurationGenerator if bufferedDurationGeneratorEnable was set true';
    }
    if (!_bufferedDurationGeneratorEnable &&
        bufferedDurationGenerator != null) {
      throw 'Must set bufferedDurationGeneratorEnable true before set bufferedDurationGenerator';
    }
    _bufferedDurationGenerator = bufferedDurationGenerator;
    final String? url = await _channel.invokeMethod('parseStreamURL', {
      'url': sourceUrl,
      'videoId': videoId ?? sourceUrl,
    });
    // print('mobile parse R:$url S:$sourceUrl ');
    return url;
  }

  /// Get the connection state of p2p engine. 获取P2P Engine的连接状态
  @override
  Future<bool> isConnected() async =>
      (await _channel.invokeMethod('isConnected')) == true;

  /// Restart p2p engine.
  @override
  Future<void> restartP2p() => _channel.invokeMethod('restartP2p');

  /// Stop p2p and free used resources.
  @override
  Future<void> stopP2p() => _channel.invokeMethod('stopP2p');

  /// Get the peer ID of p2p engine. 获取P2P Engine的peer ID
  @override
  Future<String> getPeerId() async =>
      (await _channel.invokeMethod('getPeerId')) ?? 'Unknown peer Id';
}
