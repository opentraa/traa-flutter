import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'traa_plugin_bindings_generated.dart';

extension ArrayCharExtensions on Array<Char> {
  String toDartString() {
    var bytesBuilder = BytesBuilder();
    int index = 0;
    while (this[index] != 0) {
      bytesBuilder.addByte(this[index]);
      ++index;
    }

    var bytes = bytesBuilder.takeBytes();
    return utf8.decode(bytes);
  }
}

const String _libName = 'traa';

/// The dynamic library in which the symbols for [TraaPluginBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final TraaPluginBindings _bindings = TraaPluginBindings(_dylib);

/// Request class for enumScreenSourceInfo
class _EnumScreenSourceRequest {
  final int id;
  final traa_size iconSize;
  final traa_size thumbnailSize;
  final int externalFlags;
  final ffi.Pointer<ffi.Pointer<traa_screen_source_info>> infos;
  final ffi.Pointer<ffi.Int> count;

  const _EnumScreenSourceRequest(this.id, this.iconSize, this.thumbnailSize,
      this.externalFlags, this.infos, this.count);
}

/// Response class for enumScreenSourceInfo
class _EnumScreenSourceResponse {
  final int id;
  final int result;

  const _EnumScreenSourceResponse(this.id, this.result);
}

// Add new request counter and map
int _nextEnumRequestId = 0;
final Map<int, Completer<int>> _enumRequests = <int, Completer<int>>{};

class TraaPlugin {
  static int init(ffi.Pointer<traa_config> config) {
    return _bindings.traa_init(config);
  }

  static void release() {
    return _bindings.traa_release();
  }

  static Future<int> enumScreenSourceInfo(
      traa_size iconSize,
      traa_size thumbnailSize,
      int externalFlags,
      ffi.Pointer<ffi.Pointer<traa_screen_source_info>> infos,
      ffi.Pointer<ffi.Int> count) async {
    final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
    final int requestId = _nextEnumRequestId++;
    final request = _EnumScreenSourceRequest(
        requestId, iconSize, thumbnailSize, externalFlags, infos, count);
    final completer = Completer<int>();
    _enumRequests[requestId] = completer;
    helperIsolateSendPort.send(request);
    return completer.future;
  }

  static Future<int> freeScreenSourceInfo(
      ffi.Pointer<traa_screen_source_info> infos, int count) async {
    final completer = Completer<int>();
    final result = _bindings.traa_free_screen_source_info(infos, count);
    completer.complete(result);
    return completer.future;
  }
}

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  final Completer<SendPort> completer = Completer<SendPort>();

  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _EnumScreenSourceResponse) {
        final Completer<int> completer = _enumRequests[data.id]!;
        _enumRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is _EnumScreenSourceRequest) {
          final result = _bindings.traa_enum_screen_source_info(data.iconSize,
              data.thumbnailSize, data.externalFlags, data.infos, data.count);
          final response = _EnumScreenSourceResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  return completer.future;
}();
