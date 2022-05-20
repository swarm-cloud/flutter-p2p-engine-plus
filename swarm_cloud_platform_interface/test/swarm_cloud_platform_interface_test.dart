import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swarm_cloud_platform_interface/swarm_cloud_platform_interface.dart';

void main() {
  const MethodChannel channel = MethodChannel('swarm_cloud_platform_interface');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
