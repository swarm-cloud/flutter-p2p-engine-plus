import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swarm_cloud_ios/swarm_cloud_ios.dart';

void main() {
  const MethodChannel channel = MethodChannel('swarm_cloud_ios');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SwarmCloudIos.platformVersion, '42');
  });
}
