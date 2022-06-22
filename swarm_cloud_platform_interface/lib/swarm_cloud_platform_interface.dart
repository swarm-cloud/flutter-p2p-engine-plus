// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:swarm_cloud_platform_interface/event_channel.dart';

SegmentIdGenerator defaultSegmentIdGenerator = (
  String streamId,
  int sn,
  String segmentUrl,
  String? range,
) {
  String segId = segmentUrl;
  if (segmentUrl.contains("?")) {
    segId = segmentUrl.substring(0, segmentUrl.indexOf('?'));
  }
  if (segmentUrl.startsWith("http")) {
    segId = segmentUrl.replaceFirst(RegExp('(http|https):\\/\\/'), "");
  }
  if (range != null) {
    segId += "|" + range;
  }
  return segId;
};

typedef SegmentIdGenerator = String? Function(
  String streamId,
  int sn,
  String segmentUrl,
  String? range,
);

class SwarmCloudPlatform extends PlatformInterface {
  /// Constructs a SharePlatform.
  SwarmCloudPlatform() : super(token: _token);

  static final Object _token = Object();

  static SwarmCloudPlatform _instance = SwarmCloudChannel();

  /// The default instance of [SwarmCloudPlatform] to use.
  ///
  /// Defaults to [MethodChannelShare].
  static SwarmCloudPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SwarmCloudPlatform] when they register themselves.
  static set instance(SwarmCloudPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Create a new instance with token and the specified config.
  Future<int> init(
    token, {
    required P2pConfig config,
    void Function(Map<String, dynamic>)? infoListener,
    SegmentIdGenerator? segmentIdGenerator, // 给SDK提供segmentId
    bool bufferedDurationGeneratorEnable = false, // 是否可以给SDK提供缓冲前沿到当前播放时间的差值
  }) =>
      _instance.init(
        token,
        config: config,
        infoListener: infoListener,
        segmentIdGenerator: segmentIdGenerator,
        bufferedDurationGeneratorEnable: bufferedDurationGeneratorEnable,
      );

  /// Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
  Future<String?> parseStreamURL(
    String sourceUrl, {
    String? videoId,
    Duration Function()? bufferedDurationGenerator,
  }) =>
      _instance.parseStreamURL(
        sourceUrl,
        videoId: videoId,
        bufferedDurationGenerator: bufferedDurationGenerator,
      );

  /// Get the connection state of p2p engine. 获取P2P Engine的连接状态
  Future<bool> isConnected() => _instance.isConnected();

  /// Restart p2p engine.
  Future<void> restartP2p() => _instance.restartP2p();

  /// Stop p2p and free used resources.
  Future<void> stopP2p() => _instance.stopP2p();

  Future<void> shutdown() => _instance.shutdown();

  /// Get the peer ID of p2p engine. 获取P2P Engine的peer ID
  Future<String> getPeerId() => _instance.getPeerId();
}

/// Print log level.
enum P2pLogLevel {
  none,
  debug,
  info,
  warn,
  error,
}

/// tracker服务器地址所在国家的枚举
enum AnnounceLocation {
  China,
  HongKong,
  USA,
}

/// The configuration of p2p engine.
class P2pConfig {
  /// 打印日志的级别
  final P2pLogLevel logLevel;

  /// 通过webRTCConfig来修改WebRTC默认配置
  final Map<String, dynamic> webRTCConfig;

  /// 信令服务器地址
  final String? wsSignalerAddr;

  /// tracker服务器地址
  final String? announce;

  /// 点播模式下P2P在磁盘缓存的最大数据量(设为0可以禁用磁盘缓存)
  final int diskCacheLimit;

  /// P2P在内存缓存的最大数据量，用ts文件个数表示，仅安卓有效
  final int memoryCacheCountLimit;
  // @Deprecated('Use memoryCacheCountLimit now')
  // 仅iOS有效
  final int memoryCacheLimit;

  /// 开启或关闭p2p engine
  final bool p2pEnabled;

  /// HTTP下载ts文件超时时间
  final Duration downloadTimeout;

  /// datachannel下载二进制数据的最大超时时间
  final Duration dcDownloadTimeout;

  /// 用户自定义的标签，可以在控制台查看分布图
  final String? tag;

  /// 本地代理服务器的端口号
  final int localPort;

  /// 最大连接节点数量
  final int maxPeerConnections;

  /// 在可能的情况下使用Http Range请求来补足p2p下载超时的剩余部分数据
  final bool useHttpRange;

  /// 是否只在wifi和有线网络模式上传数据（建议在云端设置）
  final bool wifiOnly;

  /// 设置请求ts和m3u8时的HTTP请求头
  final Map<String, String>? httpHeaders;

  /// 如果运行于机顶盒请设置成true
  final bool isSetTopBox;

  /// P2P下载超时后留给HTTP下载的时间(ms)
  final int httpLoadTime;

  /// 是否允许m3u8文件的P2P传输
  final bool sharePlaylist;

  /// 是否将日志持久化到外部存储
  final bool logPersistent;

  /// iOS特有
  /// 日志文件的存储路径，默认路径是 Library/Caches/Logs/
  final String? logFilePathInIos;

  /// Android特有
  /// 优先尝试从对等端下载前几片数据，可以提高P2P比例，但可能会增加起播延时
  final bool waitForPeerInAndroid;

  /// Android特有
  /// waitForPeer的超时时间，超时后恢复从http下载(ms)
  final int waitForPeerTimeoutInAndroid;

  /// 扩展支持的HLS媒体文件
  final List<String> hlsMediaFiles;

  /// tracker服务器地址所在国家
  final AnnounceLocation? announceLocation;

  /// 自定义扩展支持的HLS媒体文件
  final List<String>? hlsMediaFileExtensions;

  P2pConfig({
    this.logLevel: P2pLogLevel.warn,
    this.webRTCConfig: const {}, // TODO: 默认值缺少
    this.wsSignalerAddr, //: 'wss://signal.cdnbye.com',
    this.announce, //: 'https://tracker.cdnbye.com/v1',
    this.diskCacheLimit: 1024 * 1024 * 1024,
    this.memoryCacheLimit: 100 * 1024 * 1024,
    this.memoryCacheCountLimit: 30,
    this.p2pEnabled: true,
    this.downloadTimeout: const Duration(seconds: 30),
    this.dcDownloadTimeout: const Duration(seconds: 6),
    this.tag,
    this.localPort: 0,
    this.maxPeerConnections: 20,
    this.useHttpRange: true,
    this.wifiOnly: false,
    this.httpHeaders,
    this.isSetTopBox: false,
    this.httpLoadTime: 2000,
    this.logPersistent: false,
    this.sharePlaylist: false,
    this.waitForPeerInAndroid: false,
    this.waitForPeerTimeoutInAndroid: 4500,
    this.hlsMediaFiles: const ["ts", "mp4", "m4s"],
    this.logFilePathInIos,
    // 新
    this.announceLocation,
    this.hlsMediaFileExtensions,
  });

  P2pConfig.byDefault() : this();

  Map<String, dynamic> get toMap => {
        'logLevel': logLevel.index,
        'webRTCConfig': webRTCConfig,
        'wsSignalerAddr': wsSignalerAddr,
        'announce': announce,
        'diskCacheLimit': diskCacheLimit,
        'memoryCacheLimit': memoryCacheLimit,
        'memoryCacheCountLimit': memoryCacheCountLimit,
        'p2pEnabled': p2pEnabled,
        'downloadTimeout': downloadTimeout.inSeconds,
        'dcDownloadTimeout': dcDownloadTimeout.inSeconds,
        'tag': tag,
        'localPort': localPort,
        'maxPeerConnections': maxPeerConnections,
        'useHttpRange': useHttpRange,
        'wifiOnly': wifiOnly,
        'httpHeaders': httpHeaders ?? {},
        'isSetTopBox': isSetTopBox,
        'httpLoadTime': httpLoadTime,
        'sharePlaylist': sharePlaylist,
        'logPersistent': logPersistent,
        'logFilePath': logFilePathInIos,
        'waitForPeer': waitForPeerInAndroid,
        'waitForPeerTimeout': waitForPeerTimeoutInAndroid,
        'hlsMediaFiles': hlsMediaFiles,
        // new
        'announceLocation': announceLocation?.index,
        'hlsMediaFileExtensions': hlsMediaFileExtensions,
      };
}
