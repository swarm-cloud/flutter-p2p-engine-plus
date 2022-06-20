---
title: 簡介
---

::: tip
Flutter視頻/直播APP省流量&加速引擎!
:::

<a href="https://pub.dartlang.org/packages/swarm_cloud">< img src="https://img.shields.io/pub/v/swarm_cloud.svg" alt="pub"></a >
### 特性
- 支持iOS和安卓平臺，可與[Web端插件](https://github.com/cdnbye/hlsjs-p2p-engine)P2P互通
- 支持基於HLS流媒體協議(m3u8)的直播和點播場景
- 支持加密HLS傳輸和防盜鏈技術
- 支持ts文件緩存從而避免重復下載
- 幾行代碼即可在現有Flutter項目中快速集成
- 支持任何Flutter播放器
- 通過預加載形式實現P2P加速，完全不影響用戶的播放體驗
- 高可配置化，用戶可以根據特定的使用環境調整各個參數
- 通過有效的調度策略來保證用戶的播放體驗以及p2p分享率
- Tracker服務器根據訪問IP的ISP、地域等進行智能調度
- 完美兼容安卓機頂盒

### 演示Demo
[http://d.6short.com/cdnbye](http://d.6short.com/cdnbye)

### 系統要求
Dart SDK 版本 >= 2.12.0
<br>
Flutter 版本 >= 2.0
<br>
安卓4.4以上版本(API level >= 19)
<br>
iOS 10.0以上系統。

### 獲取Token
參考[如何獲取token](/cn/views/bindings.html#綁定-app-id-並獲取token)

### 局限性
- 在音頻和視頻軌分離的情況下，只有視頻軌能獲得P2P加速
- 不能同時為2個以上(含2個)視頻進行P2P加速
- 暂不支持 LL-HLS

### 技術支持
移動端SDK技術支持QQ群：901641535
