import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_preload_videos/core/build_context.dart';
import 'package:flutter_preload_videos/core/constants.dart';
import 'package:flutter_preload_videos/service/api_service.dart';

Future createIsolate({
  required int index,
  required Function(BuildContext) setLoading,
  required Function(List<String>) updateUrls,
}) async {
  /// Set loading to true
  setLoading(context);

  ReceivePort mainReceivePort = ReceivePort();

  Isolate.spawn<SendPort>(_getVideosTask, mainReceivePort.sendPort);

  SendPort isolateSendPort = await mainReceivePort.first;

  ReceivePort isolateResponseReceivePort = ReceivePort();

  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  final isolateResponse = await isolateResponseReceivePort.first;
  final _urls = isolateResponse;

  /// Update new urls
  updateUrls(_urls);
}

void _getVideosTask(SendPort mySendPort) async {
  ReceivePort isolateReceivePort = ReceivePort();

  mySendPort.send(isolateReceivePort.sendPort);

  await for (var message in isolateReceivePort) {
    if (message is List) {
      final index = message[0];

      final isolateResponseSendPort = message[1];

      final _urls = await ApiService.getVideos(
        id: index + kPreloadLimit,
      );

      isolateResponseSendPort.send(_urls);
    }
  }
}
