import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swarm_cloud/swarm_cloud.dart';

void main() {
  const MethodChannel channel = MethodChannel('swarm_cloud');

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
    // expect(await SwarmCloud.platformVersion, '42');
  });
}
