import 'dart:html';

import 'package:flutter/services.dart';
import 'package:swarm_cloud/swarm_cloud.dart';
import 'package:swarm_cloud_example/style/color.dart';
import 'package:swarm_cloud_example/views/confirm.dart';
import 'package:tapped/tapped.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const VideoApp());

  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class VideoApp extends StatelessWidget {
  const VideoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController _controller = VideoPlayerController.network('');

  @override
  void initState() {
    super.initState();
    print('init');
    init();
  }

  var url =
      'https://video.cdnbye.com/0cf6732evodtransgzp1257070836/e0d4b12e5285890803440736872/v.f100220.m3u8';
  var urlResult = "";
  var token = 'ZMuO5qHZg';

  init() async {
    try {
      await SwarmCloud.init(
        token,
        config: P2pConfig(
          logLevel: P2pLogLevel.debug,
        ),
        infoListener: (info) {
          window.console.log(info);
          print('p2p listen: $info');
        },
        segmentIdGenerator: (
          String streamId,
          int sn,
          String segmentUrl,
          String? range,
        ) {
          print('segmentIdGenerator');
          return segmentUrl;
        },
      );
      urlResult = await SwarmCloud.parseStreamURL(url) ?? url;
      setState(() {});
      _controller = VideoPlayerController.network(urlResult)
        ..initialize().then((_) {
          setState(() {});
        });
      _controller.setVolume(0.0);
    } catch (e) {
      print(e);
    }
    // print('Swarm Cloud Version: $engineVersion');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPlate.lightGray,
      body: Center(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
            ),
            Positioned(
              left: 12,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Url:$url'),
                            Text('UrlResult:$urlResult'),
                            Text('Token:$token'),
                          ],
                        ),
                      ),
                      Tapped(
                        onTap: () async {
                          var res = await editUrlAndToken(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Tapped(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Tapped(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// 输入文本，可以通过onWillConfirm方法检查
Future<String?> editUrlAndToken(
  BuildContext context, {
  ConfirmType? type,
  String? url,
  String? token,
}) async {
  InputHelper urlInput = InputHelper(defaultText: url);
  InputHelper tokenInput = InputHelper(defaultText: token);
  var res = await confirm(
    context,
    type: type,
    title: 'Edit',
    ok: 'Save',
    cancel: 'Cancel',
    onWillConfirm: () async => true,
    contentBuilder: (ctx) => Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: ColorPlate.lightGray,
            borderRadius: BorderRadius.circular(6),
          ),
          child: StInput.helper(
            autofocus: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            maxLength: 120,
            clearable: true,
            helper: tokenInput,
            hintText: 'Input Token',
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: ColorPlate.lightGray,
            borderRadius: BorderRadius.circular(6),
          ),
          child: StTextField(
            autofocus: true,
            margin: EdgeInsets.zero,
            helper: urlInput,
            hintText: 'Input Url',
          ),
        ),
      ],
    ),
  );
  if (res == true) {
    return urlInput.text;
  }
  return null;
}
