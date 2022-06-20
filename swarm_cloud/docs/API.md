---
title: API文档
---

## P2P 配置

实例化 **_P2pConfig_** ：

```dart
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

  /// 如果使用自定义的channelId，则此字段必须设置，且长度必须在5到15个字符之间，建议设置成你所在组织的唯一标识
  // final String? channelIdPrefix;

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
    this.webRTCConfig: const {},
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
}

```

## API 支持度

P2pConfig:

| 属性                        | iOS | Android | Web |
| :-------------------------- | :-: | :-----: | :-: |
| logLevel                    | ✅  |   ✅    | ✅  |
| webRTCConfig                | ✅  |   ✅    | ✅  |
| wsSignalerAddr              | ✅  |   ✅    | ❌  |
| announce                    | ❌  |   ✅    | ✅  |
| diskCacheLimit              | ✅  |   ✅    | ❌  |
| memoryCacheLimit            | ✅  |   ✅    | ✅  |
| memoryCacheCountLimit       | ✅  |   ✅    | ❌  |
| p2pEnabled                  | ✅  |   ✅    | ✅  |
| downloadTimeout             | ✅  |   ✅    | ❌  |
| dcDownloadTimeout           | ✅  |   ✅    | ❌  |
| tag                         | ✅  |   ✅    | ❌  |
| localPort                   | ✅  |   ✅    | ❌  |
| maxPeerConnections          | ✅  |   ✅    | ❌  |
| useHttpRange                | ✅  |   ✅    | ✅  |
| wifiOnly                    | ✅  |   ✅    | ❌  |
| httpHeaders                 | ✅  |   ✅    | ✅  |
| isSetTopBox                 | ✅  |   ✅    | ❌  |
| httpLoadTime                | ✅  |   ✅    | ✅  |
| logPersistent               | ✅  |   ✅    | ❌  |
| sharePlaylist               | ✅  |   ✅    | ✅  |
| waitForPeerInAndroid        | ❌  |   ✅    | ❌  |
| waitForPeerTimeoutInAndroid | ❌  |   ✅    | ❌  |
| hlsMediaFiles               | ✅  |   ✅    | ❌  |
| logFilePathInIos            | ✅  |   ✅    | ❌  |
| announceLocation            | ✅  |   ✅    | ❌  |
| hlsMediaFileExtensions      | ✅  |   ✅    | ❌  |

## P2pEngine

实例化 P2pEngine，获得一个全局单例：

```dart
// 初始化
SwarmCloud.init(
  token, // replace with your token
  config: P2pConfig.byDefault()
);
```

参数说明:
<br>

|     参数     |   类型    | 是否必须 |           说明            |
| :----------: | :-------: | :------: | :-----------------------: |
| **_token_**  |  String   |    是    | SwarmCloud 分配的 token。 |
| **_config_** | P2pConfig |    否    |       自定义配置。        |

### 切换源

当播放器切换到新的播放地址时，只需要将新的播放地址(m3u8)传给 **_SwarmCloud_**，从而获取新的本地播放地址：

```dart
String parsedUrl = await SwarmCloud.parseStreamURL(url);
```

### SwarmCloud API

```dart
/// SDK的版本号
static Future<String> get platformVersion

/// 实例化P2pEngine，获得一个全局单例。
static Future<int> init(
  token, {
  P2pConfig config,
  void Function(Map<String, dynamic>)? infoListener,
  String Function(int level, int sn, String url) segmentIdGenerator,
})

/// 将原始播放地址(m3u8)转换成本地代理服务器的地址，同时传入videoId用以构造channelId。
static Future<String> parseStreamURL(
  String sourceUrl, [
  String videoId,
])

/// 获取P2P Engine的连接状态
static Future<bool> isConnected()

/// 重启P2P加速服务，一般不需要调用。
static Future restartP2p()

/// 停止P2P加速并释放资源，一般不需要调用。SDK采用"懒释放"的策略，只有在重启p2p的时候才释放资源。对于性能较差的设备起播耗时可能比较明显，建议在视频播放之前提前调用 engine.stopP2p() 。
static Future stopP2p()

/// 获取P2P Engine的peer ID
static Future<String> getPeerId()
```

### P2P 统计

请参考 [example](https://github.com/cdnbye/flutter-p2p-engine/tree/master/example)。

::: warning
下载和上传数据量的单位是 KB。
:::

### 回调播放器信息

在直播模式下，为了增强 P2P 效果并提高播放流畅度，建议通过 **_bufferedDurationGenerator_** ，将从当前播放时间到缓冲前沿的时间间隔回调给 p2p engine。

```dart
SwarmCloud.init(
  token, // replace with your token
  bufferedDurationGeneratorEnable: true,
);
String parsedUrl = await Cdnbye.parseStreamURL(
  url,
  bufferedDurationGenerator: () {
    return vpController!.value.buffered.last.end - vpController!.value.position;
  },
);
```

### 解决动态 m3u8 路径问题

某些流媒体提供商的 m3u8 是动态生成的，不同节点的 m3u8 地址不一样，例如 example.com/clientId1/streamId.m3u8 和 example.com/clientId2/streamId.m3u8, 而本插件默认使用 m3u8 地址(去掉查询参数)作为 channelId。这时候就要构造一个共同的 chanelId，使实际观看同一直播/视频的节点处在相同频道中。构造 channelId 方法如下：

```dart
SwarmCloud.init(
  token,   // replace with your token
  segmentIdGenerator: (streamId, int sn, String segmentUrl, String? range) {
    return '$sn';
  }
);
// 根据url构造videoId
String videoId = extractVideoIdFromUrl(originalUrl);     // extractVideoIdFromUrl 需要自己定义，可以抽取url中的视频ID作为结果返回
String url = await SwarmCloud.parseStreamURL(originalUrl, videoId);
```

::: warning
如果要与其他平台互通，则必须确保两者拥有相同的 token 和 channelId 。
:::

### 解决动态 ts 路径问题

类似动态 m3u8 路径问题，相同 ts 文件的路径也可能有差异，这时候需要忽略 ts 路径差异的部分。插件默认用 ts 的绝地路径(url)来标识每个 ts 文件，所以需要通过钩子函数重新构造标识符。可以按如下设置：

```dart
// 初始化
SwarmCloud.init(
  token,   // replace with your token
  segmentIdGenerator: (streamId, int sn, String segmentUrl, String? range) {
    return '$sn';
  }
);
```

### 设置 HTTP 请求头

出于防盗链或者统计的需求，有些 HTTP 请求需要加上 **_referer_** 或者 **_User-Agent_** 等头信息，可以通过 **_httpHeaders_** 进行设置：

```dart
P2pConfig(
  httpHeaders: {
    "referer": "XXX",
    "User-Agent": "XXX",
  }
)
```
