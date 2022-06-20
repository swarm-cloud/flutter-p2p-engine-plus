---
title: 使用方法
---

### 引入插件
在项目的 ***pubspec.yaml*** 中添加依赖：
```
dependencies:
  swarm_cloud: ^0.3.4
```

也可以使用命令：
```
  flutter pub add swarm_cloud
```

### iOS

将项目文件的 ***ios/Podfile*** 中第二行的 ***# platform :ios, '10.0'*** 的井号去掉。
<br>
CDNBye通过本地代理服务器拦截数据请求的方式来进行P2P缓存和传输，所以需要在项目的info.plist中允许HTTP请求：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Android
在 ***app/src/main*** 目录中的 ***AndroidManifest.xml*** 中增加如下权限声明:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```
从Android P系统开始，如果应用使用的是非加密的明文流量的http网络请求，则会导致该应用无法进行网络请求，https则不会受影响。由于本地代理服务需要使用http协议访问，针对这个问题，有以下两种解决方法：
<br>
（1） ***targetSdkVersion*** 降到27以下
<br>
（2） 更改网络安全配置，在 ***app/src/main*** 目录中的 ***AndroidManifest.xml*** 的 `<application>` 标签中直接插入：
```xml
<application
  ...
  android:usesCleartextTraffic="true"
  ...
    />
```

### 示例
```dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:swarm_cloud/swarm_cloud.dart';

// Init p2p engine
_initEngine();

// Start playing video
_loadVideo();

_initEngine() async {
    await SwarmCloud.init(
      YOUR_TOKEN,
      config: P2pConfig.byDefault()
    );
}

_loadVideo() async {
    var url = YOUR_STREAM_URL;
    url = await SwarmCloud.parseStreamURL(url);           // Parse your stream url
    player = VideoPlayerController.network(url);
}
```

### Web

> 请注意要在web上播放，请使用videoplayer进行播放。目前videoplayer是flutter上唯一支持web平台的播放器，若要在其他支持web的播放器上使用，需要本插件另外支持。

在./web/index.html文件中添加标签，加在body第一行即可
```javascript
<body>
  <script src="https://unpkg.com/cdnbye@latest"></script>
  ...Other Code
```
