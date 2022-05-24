@JS()
library hls.js;

import 'dart:html';

import 'package:js/js.dart';

@JS('Hls.isSupported')
external bool isSupported();

@JS('Hls.engineVersion')
external String engineVersion;

@JS('Hls.WEBRTC_SUPPORT')
external bool WEBRTC_SUPPORT;

@JS()
class Hls {
  external factory Hls(HlsConfig config);

  @JS()
  external void stopLoad();

  @JS()
  external void loadSource(String videoSrc);

  @JS()
  external void attachMedia(VideoElement video);

  @JS()
  external void on(String event, Function callback);

  external HlsConfig config;
}

@JS()
@anonymous
class HlsConfig {
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

  @JS()
  external Function get xhrSetup;

  external factory HlsConfig({Function xhrSetup});
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
