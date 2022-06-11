@JS()
library hls.js;

import 'dart:html';

import 'package:js/js.dart';

@JS('Hls.isSupported')
external bool _isSupported();

@JS('Hls.engineVersion')
external String _engineVersion;

@JS('Hls.WEBRTC_SUPPORT')
external bool _WEBRTC_SUPPORT;

@JS('P2PEngine.protocolVersion')
external bool _protocolVersion;

@JS('P2PEngine.version')
external bool _version;

class P2P {
  static bool get isSupported => _isSupported();

  static String get engineVersion => _engineVersion;

  static bool get WEBRTC_SUPPORT => _WEBRTC_SUPPORT;

  static bool get protocolVersion => _protocolVersion;

  static bool get version => _version;
}

@JS()
class P2PEngine {
  @JS()
  external void on(String event, Function callback);

  @JS()
  external void enableP2P();
  
  @JS()
  external void disableP2P();
  
  @JS()
  external void destroy();
}

@JS()
class Hls {
  external factory Hls(P2PHlsConfig config);

  @JS()
  external void stopLoad();

  @JS()
  external void loadSource(String videoSrc);

  @JS()
  external void attachMedia(VideoElement video);

  @JS()
  external void on(String event, Function callback);

  external P2PEngine p2pEngine;

  external P2PHlsConfig config;
}

@JS()
@anonymous
class P2PHlsConfig {
  @JS()
  external Function get xhrSetup;

  // @JS()
  // external dynamic Function(dynamic data)? getStats;
  @JS()
  external Function get getStats;

  external factory P2PHlsConfig({
    Function xhrSetup,
    P2PSettingConfig p2pConfig,
  });
}

@JS()
@anonymous
class P2PSettingConfig {
  external factory P2PSettingConfig({
    /// 获取p2p下载信息
    /// 该回调函数可以获取p2p信息，包括：
    /// totalHTTPDownloaded: 从HTTP(CDN)下载的数据量（单位KB）
    /// totalP2PDownloaded: 从P2P下载的数据量（单位KB）
    /// totalP2PUploaded: P2P上传的数据量（单位KB）
    /// p2pDownloadSpeed: P2P下载速度（单位KB/s）
    void Function(
      int totalP2PDownloaded,
      int totalP2PUploaded,
      int totalHTTPDownloaded,
      int p2pDownloadSpeed,
    )?
        getStats,

    /// 获取本节点的Id
    void Function(int peerId)? getPeerId,

    /// 获取成功连接的节点的信息
    void Function(int peers)? getPeersInfo,

    /// 某些流媒体提供商的m3u8是动态生成的
    /// 不同节点的m3u8地址不一样
    /// 例如example.com/clientId1/streamId.m3u8和example.com/clientId2/streamId.m3u8
    /// 而本插件默认使用m3u8地址(去掉查询参数)作为channelId。
    /// 这时候就要构造一个共同的chanelId，使实际观看同一直播/视频的节点处在相同频道中。
    String? Function(int m3u8Url)? channelId,

    /// 解决动态ts路径问题
    /// 类似动态m3u8路径问题，相同ts文件的路径也可能有差异
    /// 这时候需要忽略ts路径差异的部分
    /// 插件默认用ts的绝地路径(url)来标识每个ts文件
    /// 所以需要通过钩子函数重新构造标识符。
    dynamic Function(
      String streamId,
      int sn,
      String segmentUrl,
      String? range,
    )?
        segmentId,
  });

  /// 默认：boolean	'error'	log的等级，分为'warn'、'error'、'none'，设为true等于'warn'，设为false等于'none'。
  external String? logLevel;

  ///	默认：undefined	token用于控制台多域名数据汇总展示，另外如果自定义channelId也需要设置token。
  external String? token;

  ///	默认：true	设置直播或者点播模式，不同模式会自动设置不同的hls.js参数。
  external bool? live;

  ///	默认：https://tracker.cdnbye.com/v1'	tracker服务器地址。
  external String? announce;

  ///	默认：cn'	tracker服务器地址的国家代号，分为'cn'、'hk'、'us'。
  external String? announceLocation;

  ///	默认：{"pc": 800 * 1024 * 1024, "mobile": 500 * 1024 * 1024}	p2p缓存的最大数据量，分为PC和mobile。
  external Object? memoryCacheLimit;

  ///	默认：true	是否开启P2P。
  external bool? p2pEnabled;

  ///	默认：{}	用于配置stun和datachannel的字典 (opens new window)。
  external Object? webRTCConfig;

  ///	默认：true	在可能的情况下使用Http Range请求来补足p2p下载超时的剩余部分数据。
  external bool? useHttpRange;

  ///	默认：false	优先尝试从对等端下载前几片数据，可以提高P2P比例，但可能会增加起播延时。
  external bool? waitForPeer;

  ///	默认：4.5	waitForPeer的超时时间(单位秒)，超时后恢复从http下载。
  external int? waitForPeerTimeout;

  ///	默认：2.0	P2P下载超时后留给HTTP下载的时间。
  external int? httpLoadTime;

  ///	默认：false	是否允许m3u8文件的P2P传输。
  external bool? sharePlaylist;

  ///	默认：true	向在线IP数据库请求ASN等信息，从而获得更准确的调度，会延迟P2P启动时间。
  external bool? geoIpPreflight;
}

class ErrorData {
  late final String type;
  late final String details;
  late final bool fatal;
  ErrorData(dynamic errorData) {
    type = errorData.type as String;
    details = errorData.details as String;
    fatal = errorData.fatal as bool;
  }
}
