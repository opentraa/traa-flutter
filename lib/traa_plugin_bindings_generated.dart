// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings for `thirdparty/traa/include/traa/traa.h`.
///
/// Regenerate bindings with `dart run ffigen --config ffigen.yaml`.
///
class TraaPluginBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  TraaPluginBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  TraaPluginBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// @brief The configuration for TRAA.
  ///
  /// This is the configuration for TRAA.
  ///
  /// @param config The configuration for TRAA.
  int traa_init(
    ffi.Pointer<traa_config> config,
  ) {
    return _traa_init(
      config,
    );
  }

  late final _traa_initPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<traa_config>)>>(
          'traa_init');
  late final _traa_init =
      _traa_initPtr.asFunction<int Function(ffi.Pointer<traa_config>)>();

  /// @brief The release for TRAA.
  ///
  /// This is the release for TRAA, which releases all resources and cleans up all internal state, all
  /// unfinished tasks will be canceled.
  void traa_release() {
    return _traa_release();
  }

  late final _traa_releasePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('traa_release');
  late final _traa_release = _traa_releasePtr.asFunction<void Function()>();

  /// @brief Sets the event handler for the TRAA library.
  ///
  /// This function allows you to set the event handler for the TRAA library.
  /// The event handler is used to handle TRAA events, such as log messages.
  ///
  /// @param handler A pointer to a `traa_event_handler` struct that contains the event handler
  /// function pointers.
  /// @return An integer value indicating the success or failure of the operation.
  /// A return value of 0 indicates success, while a non-zero value
  /// indicates failure.
  int traa_set_event_handler(
    ffi.Pointer<traa_event_handler> handler,
  ) {
    return _traa_set_event_handler(
      handler,
    );
  }

  late final _traa_set_event_handlerPtr = _lookup<
          ffi
          .NativeFunction<ffi.Int Function(ffi.Pointer<traa_event_handler>)>>(
      'traa_set_event_handler');
  late final _traa_set_event_handler = _traa_set_event_handlerPtr
      .asFunction<int Function(ffi.Pointer<traa_event_handler>)>();

  /// @brief The set log level for TRAA.
  ///
  /// This is the set log level for TRAA, which is default to TRAA_LOG_LEVEL_INFO.
  /// This is stateless and can be called at any time.
  ///
  /// @param level The log level for TRAA.
  void traa_set_log_level(
    int level,
  ) {
    return _traa_set_log_level(
      level,
    );
  }

  late final _traa_set_log_levelPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int32)>>(
          'traa_set_log_level');
  late final _traa_set_log_level =
      _traa_set_log_levelPtr.asFunction<void Function(int)>();

  /// @brief Sets the log configuration for the TRAA library.
  ///
  /// This function allows you to set the log configuration for the TRAA library.
  /// The log configuration specifies the log level, log file path, and other
  /// log-related settings.
  ///
  /// @param config A pointer to a `traa_log_config` struct that contains
  /// the log configuration settings.
  /// @return An integer value indicating the success or failure of the operation.
  /// A return value of 0 indicates success, while a non-zero value
  /// indicates failure.
  int traa_set_log(
    ffi.Pointer<traa_log_config> config,
  ) {
    return _traa_set_log(
      config,
    );
  }

  late final _traa_set_logPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Pointer<traa_log_config>)>>(
      'traa_set_log');
  late final _traa_set_log =
      _traa_set_logPtr.asFunction<int Function(ffi.Pointer<traa_log_config>)>();

  /// @brief Enumerates the devices of the specified type.
  ///
  /// This function enumerates the devices of the specified type and returns the device information.
  ///
  /// @param type The type of devices to enumerate.
  /// @param infos A pointer to an array of traa_device_info structures to store the device
  /// information.
  /// @param count A pointer to an integer to store the number of devices found.
  /// @return An integer value indicating the success or failure of the operation.
  /// A return value of 0 indicates success, while a non-zero value
  /// indicates failure.
  int traa_enum_device_info(
    int type,
    ffi.Pointer<ffi.Pointer<traa_device_info>> infos,
    ffi.Pointer<ffi.Int> count,
  ) {
    return _traa_enum_device_info(
      type,
      infos,
      count,
    );
  }

  late final _traa_enum_device_infoPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Int32,
              ffi.Pointer<ffi.Pointer<traa_device_info>>,
              ffi.Pointer<ffi.Int>)>>('traa_enum_device_info');
  late final _traa_enum_device_info = _traa_enum_device_infoPtr.asFunction<
      int Function(int, ffi.Pointer<ffi.Pointer<traa_device_info>>,
          ffi.Pointer<ffi.Int>)>();

  /// @brief Frees the memory allocated for the device information.
  ///
  /// This function frees the memory allocated for the device information.
  ///
  /// @param infos A pointer to an array of traa_device_info structures to free.
  /// @return An integer value indicating the success or failure of the operation.
  ///
  /// @note This function must be called to free the memory allocated for the device information.
  int traa_free_device_info(
    ffi.Pointer<traa_device_info> infos,
  ) {
    return _traa_free_device_info(
      infos,
    );
  }

  late final _traa_free_device_infoPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Pointer<traa_device_info>)>>(
      'traa_free_device_info');
  late final _traa_free_device_info = _traa_free_device_infoPtr
      .asFunction<int Function(ffi.Pointer<traa_device_info>)>();

  /// @brief Enumerates the screen sources.
  ///
  /// This function enumerates the screen sources and returns the screen source information.
  ///
  /// @param icon_size The size of the icon.
  /// @param thumbnail_size The size of the thumbnail.
  /// @param external_flags The external flags. See traa_screen_source_flags for more information
  /// @param infos A pointer to an array of traa_screen_source_info structures to store the screen
  /// source information.
  /// @param count A pointer to an integer to store the number of screen sources found.
  /// @return An integer value indicating the success or failure of the operation.
  /// A return value of 0 indicates success, while a non-zero value
  /// indicates failure.
  int traa_enum_screen_source_info(
    traa_size icon_size,
    traa_size thumbnail_size,
    int external_flags,
    ffi.Pointer<ffi.Pointer<traa_screen_source_info>> infos,
    ffi.Pointer<ffi.Int> count,
  ) {
    return _traa_enum_screen_source_info(
      icon_size,
      thumbnail_size,
      external_flags,
      infos,
      count,
    );
  }

  late final _traa_enum_screen_source_infoPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              traa_size,
              traa_size,
              ffi.UnsignedInt,
              ffi.Pointer<ffi.Pointer<traa_screen_source_info>>,
              ffi.Pointer<ffi.Int>)>>('traa_enum_screen_source_info');
  late final _traa_enum_screen_source_info =
      _traa_enum_screen_source_infoPtr.asFunction<
          int Function(
              traa_size,
              traa_size,
              int,
              ffi.Pointer<ffi.Pointer<traa_screen_source_info>>,
              ffi.Pointer<ffi.Int>)>();

  /// @brief Frees the memory allocated for the screen source information.
  ///
  /// This function frees the memory allocated for the screen source information.
  ///
  /// @param infos A pointer to an array of traa_screen_source_info structures to free.
  /// @param count The number of screen sources.
  /// @return An integer value indicating the success or failure of the operation.
  ///
  /// @note This function must be called to free the memory allocated for the screen source
  /// information.
  int traa_free_screen_source_info(
    ffi.Pointer<traa_screen_source_info> infos,
    int count,
  ) {
    return _traa_free_screen_source_info(
      infos,
      count,
    );
  }

  late final _traa_free_screen_source_infoPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<traa_screen_source_info>,
              ffi.Int)>>('traa_free_screen_source_info');
  late final _traa_free_screen_source_info = _traa_free_screen_source_infoPtr
      .asFunction<int Function(ffi.Pointer<traa_screen_source_info>, int)>();
}

/// @brief The configuration structure for the traa library.
///
/// This structure holds the configuration options for the traa library.
/// It includes the userdata, log configuration, and event handler.
final class traa_config extends ffi.Struct {
  /// @brief The userdata associated with the traa library.
  ///
  /// This userdata is passed to the event handler functions.
  external traa_userdata userdata;

  /// @brief The log configuration for the traa library.
  ///
  /// This configuration is used to set the log file, max size, max files, and log level.
  external traa_log_config log_config;

  /// @brief The event handler for the traa library.
  ///
  /// This event handler is used to handle TRAA events.
  external traa_event_handler event_handler;
}

/// @brief The userdata for TRAA.
///
/// This is the userdata for TRAA.
typedef traa_userdata = ffi.Pointer<ffi.Void>;

/// @brief Configuration options for TRAA logging.
///
/// This struct defines the configuration options for TRAA logging. It specifies the log file,
/// maximum size of the log file, maximum number of log files, and log level.
final class traa_log_config extends ffi.Struct {
  /// @brief The log file for TRAA.
  ///
  /// This is the file where the log messages are written.
  /// If this is set to `nullptr`, the log messages are written to the console by default, and other
  /// log options are ignored when you call `traa_init` or `traa_set_log_config`.
  external ffi.Pointer<ffi.Char> log_file;

  /// @brief The maximum size of the log file.
  ///
  /// This is the maximum size of the log file in bytes.
  @ffi.Int32()
  external int max_size;

  /// @brief The maximum number of log files.
  ///
  /// This is the maximum number of log files that are kept.
  @ffi.Int32()
  external int max_files;

  /// @brief The log level for TRAA.
  ///
  /// This is the log level for the log messages, which defaults to `TRAA_LOG_LEVEL_INFO`.
  @ffi.Int32()
  external int level;
}

/// @brief The log level for TRAA.
///
/// This is the log level for TRAA.
abstract class traa_log_level {
  /// @brief The trace log level.
  ///
  /// This is the trace log level.
  static const int TRAA_LOG_LEVEL_TRACE = 0;

  /// @brief The debug log level.
  ///
  /// This is the debug log level.
  static const int TRAA_LOG_LEVEL_DEBUG = 1;

  /// @brief The info log level.
  ///
  /// This is the info log level.
  static const int TRAA_LOG_LEVEL_INFO = 2;

  /// @brief The warn log level.
  ///
  /// This is the warn log level.
  static const int TRAA_LOG_LEVEL_WARN = 3;

  /// @brief The error log level.
  ///
  /// This is the error log level.
  static const int TRAA_LOG_LEVEL_ERROR = 4;

  /// @brief The fatal log level.
  ///
  /// This is the fatal log level.
  static const int TRAA_LOG_LEVEL_FATAL = 5;

  /// @brief The off log level.
  ///
  /// This is the off log level.
  static const int TRAA_LOG_LEVEL_OFF = 6;
}

/// @brief Structure representing an event handler for TRAA.
///
/// This structure defines a set of function pointers that can be used to handle TRAA events.
final class traa_event_handler extends ffi.Struct {
  /// @brief Function pointer for handling log messages.
  ///
  /// This function pointer is called when a log message is generated by TRAA.
  ///
  /// @param userdata The user data associated with the event handler.
  /// @param level The log level of the message.
  /// @param message The log message.
  external ffi.Pointer<
      ffi.NativeFunction<
          ffi.Void Function(traa_userdata userdata, ffi.Int32 error,
              ffi.Pointer<ffi.Char> message)>> on_error;

  /// @brief Function pointer for handling device events.
  ///
  /// This function pointer is called when a device event occurs in TRAA.
  ///
  /// @param userdata The user data associated with the event handler.
  /// @param info The device information associated with the event.
  /// @param event The event that occurred.
  external ffi.Pointer<
      ffi.NativeFunction<
          ffi.Void Function(
              traa_userdata userdata,
              ffi.Pointer<traa_device_info> info,
              ffi.Int32 event)>> on_device_event;
}

/// @brief The error codes for TRAA.
///
/// This is the error codes for TRAA.
abstract class traa_error {
  /// @brief No error.
  ///
  /// This is no error.
  static const int TRAA_ERROR_NONE = 0;

  /// @brief Unknown error.
  ///
  /// This is an unknown error.
  static const int TRAA_ERROR_UNKNOWN = 1;

  /// @brief Invalid argument error.
  ///
  /// This is an invalid argument error.
  static const int TRAA_ERROR_INVALID_ARGUMENT = 2;

  /// @brief Invalid state error.
  ///
  /// This is an invalid state error.
  static const int TRAA_ERROR_INVALID_STATE = 3;

  /// @brief Not implemented error.
  ///
  /// This is a not implemented error.
  static const int TRAA_ERROR_NOT_IMPLEMENTED = 4;

  /// @brief Not supported error.
  ///
  /// This is a not supported error.
  static const int TRAA_ERROR_NOT_SUPPORTED = 5;

  /// @brief Out of memory error.
  ///
  /// This is an out of memory error.
  static const int TRAA_ERROR_OUT_OF_MEMORY = 6;

  /// @brief Out of range error.
  ///
  /// This is an out of range error.
  static const int TRAA_ERROR_OUT_OF_RANGE = 7;

  /// @brief Permission denied error.
  ///
  /// This is a permission denied error.
  static const int TRAA_ERROR_PERMISSION_DENIED = 8;

  /// @brief Resource busy error.
  ///
  /// This is a resource busy error.
  static const int TRAA_ERROR_RESOURCE_BUSY = 9;

  /// @brief Resource exhausted error.
  ///
  /// This is a resource exhausted error.
  static const int TRAA_ERROR_RESOURCE_EXHAUSTED = 10;

  /// @brief Resource unavailable error.
  ///
  /// This is a resource unavailable error.
  static const int TRAA_ERROR_RESOURCE_UNAVAILABLE = 11;

  /// @brief Timed out error.
  ///
  /// This is a timed out error.
  static const int TRAA_ERROR_TIMED_OUT = 12;

  /// @brief Too many requests error.
  ///
  /// This is too many requests error.
  static const int TRAA_ERROR_TOO_MANY_REQUESTS = 13;

  /// @brief Unavailable error.
  ///
  /// This is an unavailable error.
  static const int TRAA_ERROR_UNAVAILABLE = 14;

  /// @brief Unauthorized error.
  ///
  /// This is an unauthorized error.
  static const int TRAA_ERROR_UNAUTHORIZED = 15;

  /// @brief Unsupported media type error.
  ///
  /// This is an unsupported media type error.
  static const int TRAA_ERROR_UNSUPPORTED_MEDIA_TYPE = 16;

  /// @brief Already exists error.
  ///
  /// This is an already exists error.
  static const int TRAA_ERROR_ALREADY_EXISTS = 17;

  /// @brief Not found error.
  ///
  /// This is a not found error.
  static const int TRAA_ERROR_NOT_FOUND = 18;

  /// @brief Not initialized error.
  ///
  /// This is a not initialized error.
  static const int TRAA_ERROR_NOT_INITIALIZED = 19;

  /// @brief Already initialized error.
  ///
  /// This is an already initialized error.
  static const int TRAA_ERROR_ALREADY_INITIALIZED = 20;

  /// @brief Enumerate screen source info failed error.
  ///
  /// This is an enumerate screen source info failed error.
  ///
  /// @note This error will be returned when the x11 is not enabled or current is running under
  /// wayland on linux. In this case, you don't need to call this function, just call the start
  /// screen capture function.
  static const int TRAA_ERROR_ENUM_SCREEN_SOURCE_INFO_FAILED = 21;

  /// @brief Error count.
  ///
  /// This is the error count.
  static const int TRAA_ERROR_COUNT = 22;
}

/// @brief The device info for TRAA.
///
/// This is the device info for TRAA.
final class traa_device_info extends ffi.Struct {
  /// @brief The device id.
  ///
  /// This is the device id.
  @ffi.Array.multi([256])
  external ffi.Array<ffi.Char> id;

  /// @brief The device name.
  ///
  /// This is the device name.
  @ffi.Array.multi([256])
  external ffi.Array<ffi.Char> name;

  /// @brief The device type.
  ///
  /// This is the device type.
  @ffi.Int32()
  external int type;

  /// @brief The device slot.
  ///
  /// This is the device slot.
  @ffi.Int32()
  external int slot;

  /// @brief The device orientation.
  ///
  /// This is the device orientation.
  @ffi.Int32()
  external int orientation;

  /// @brief The device state.
  ///
  /// This is the device state.
  @ffi.Int32()
  external int state;
}

/// @brief Enumeration of device types used in the TRAA system.
///
/// This enumeration defines the possible device types used in the TRAA system.
abstract class traa_device_type {
  static const int TRAA_DEVICE_TYPE_UNKNOWN = 0;

  /// @brief Camera device type.
  ///
  /// This is the camera device type.
  static const int TRAA_DEVICE_TYPE_CAMERA = 1;

  /// @brief Microphone device type.
  ///
  /// This is the microphone device type.
  static const int TRAA_DEVICE_TYPE_MICROPHONE = 2;

  /// @brief Speaker device type.
  ///
  /// This is the speaker device type.
  static const int TRAA_DEVICE_TYPE_SPEAKER = 3;

  /// @brief Media file device type.
  ///
  /// This is the media file device type.
  static const int TRAA_DEVICE_TYPE_MEDIA_FILE = 4;
}

/// @brief Enumeration representing the device slots for TRAA devices.
///
/// This enumeration defines the possible device slots for TRAA devices.
/// The slots include unknown, USB, Bluetooth, and network slots.
///
/// @see traa_device_slot
abstract class traa_device_slot {
  /// @brief Unknown device slot.
  ///
  /// This is the unknown device slot.
  static const int TRAA_DEVICE_SLOT_UNKNOWN = 0;

  /// @brief USB device slot.
  ///
  /// This is the USB device slot.
  static const int TRAA_DEVICE_SLOT_USB = 1;

  /// @brief Bluetooth device slot.
  ///
  /// This is the Bluetooth device slot.
  static const int TRAA_DEVICE_SLOT_BLUETOOTH = 2;

  /// @brief Network device slot.
  ///
  /// This is the network device slot.
  static const int TRAA_DEVICE_SLOT_NETWORK = 3;
}

/// @brief Enumeration representing the orientation of a TRAA device.
///
/// The traa_device_orientation enumeration defines the possible orientations of a TRAA device.
abstract class traa_device_orientation {
  /// @brief Unknown device orientation.
  ///
  /// This is the unknown device orientation.
  static const int TRAA_DEVICE_ORIENTATION_UNKNOWN = 0;

  /// @brief Front device orientation.
  ///
  /// This is the front device orientation.
  static const int TRAA_DEVICE_ORIENTATION_FRONT = 1;

  /// @brief Back device orientation.
  ///
  /// This is the back device orientation.
  static const int TRAA_DEVICE_ORIENTATION_BACK = 2;
}

/// @brief Enumeration representing the state of a TRAA device.
///
/// The traa_device_state enumeration defines the possible states of a TRAA device.
abstract class traa_device_state {
  /// @brief Idle device state.
  ///
  /// This is the idle device state.
  static const int TRAA_DEVICE_STATE_IDLE = 0;

  /// @brief Posting device state.
  ///
  /// This is the posting device state.
  static const int TRAA_DEVICE_STATE_POSTING = 1;

  /// @brief Active device state.
  ///
  /// This is the active device state.
  static const int TRAA_DEVICE_STATE_ACTIVE = 2;

  /// @brief Paused device state.
  ///
  /// This is the paused device state.
  static const int TRAA_DEVICE_STATE_PAUSED = 3;
}

/// @brief Enumeration representing the event of a TRAA device.
///
/// The traa_device_event enumeration defines the possible events of a TRAA device.
abstract class traa_device_event {
  static const int TRAA_DEVICE_EVENT_UNKNOWN = 0;

  /// operation
  static const int TRAA_DEVICE_EVENT_ATTACHING = 1;
  static const int TRAA_DEVICE_EVENT_ATTACHED = 2;
  static const int TRAA_DEVICE_EVENT_DETACHING = 3;
  static const int TRAA_DEVICE_EVENT_DETACHED = 4;

  /// nework and bluetooth
  static const int TRAA_DEVICE_EVENT_CONNECTING = 5;
  static const int TRAA_DEVICE_EVENT_CONNECTED = 6;
  static const int TRAA_DEVICE_EVENT_DISCONNECTING = 7;
  static const int TRAA_DEVICE_EVENT_DISCONNECTED = 8;

  /// usb
  static const int TRAA_DEVICE_EVENT_PLUGGING = 9;
  static const int TRAA_DEVICE_EVENT_PLUGGED = 10;
  static const int TRAA_DEVICE_EVENT_UNPLUGGING = 11;
  static const int TRAA_DEVICE_EVENT_UNPLUGGED = 12;

  /// screen and window
  static const int TRAA_DEVICE_EVENT_MINIMIZING = 13;
  static const int TRAA_DEVICE_EVENT_MINIMIZED = 14;
  static const int TRAA_DEVICE_EVENT_MAXIMIZING = 15;
  static const int TRAA_DEVICE_EVENT_MAXIMIZED = 16;
  static const int TRAA_DEVICE_EVENT_CLOSEING = 17;
  static const int TRAA_DEVICE_EVENT_CLOSED = 18;
  static const int TRAA_DEVICE_EVENT_RESIZING = 19;
  static const int TRAA_DEVICE_EVENT_RESIZED = 20;

  /// media file
  static const int TRAA_DEVICE_EVENT_MAPPING = 21;
  static const int TRAA_DEVICE_EVENT_MAPPED = 22;
  static const int TRAA_DEVICE_EVENT_UNMAPPING = 23;
  static const int TRAA_DEVICE_EVENT_UNMAPPED = 24;
}

/// @struct traa_size
/// @brief Represents the size of an object.
///
/// The traa_size struct contains the width and height of an object.
/// It is used to represent the dimensions of an object in a 2D space.
final class traa_size extends ffi.Struct {
  @ffi.Int32()
  external int width;

  @ffi.Int32()
  external int height;
}

/// @brief The screen source info for TRAA.
///
/// This is the screen source info for TRAA.
final class traa_screen_source_info extends ffi.Struct {
  /// @brief The screen source id.
  ///
  /// This is the screen source id. Default is `TRAA_INVALID_SCREEN_ID`.
  @ffi.Int64()
  external int id;

  /// @brief The screen id.
  ///
  /// Default is `TRAA_INVALID_SCREEN_ID`, only valid when current source is window.
  /// Used to identify the screen that the window is on.
  @ffi.Int64()
  external int screen_id;

  /// @brief Indicates whether the source is a window or screen.
  ///
  /// This flag indicates whether the source is a window or screen.
  @ffi.Bool()
  external bool is_window;

  /// @brief Indicates whether the source is minimized.
  ///
  /// This flag indicates whether the source is minimized.
  @ffi.Bool()
  external bool is_minimized;

  /// @brief Indicates whether the source is maximized.
  ///
  /// This flag indicates whether the source is maximized.
  @ffi.Bool()
  external bool is_maximized;

  /// @brief Indicates whether the source is primary.
  ///
  /// This flag indicates whether the source is primary.
  @ffi.Bool()
  external bool is_primary;

  /// @brief The position and size of the source.
  ///
  /// This is the position and size of the source on the full virtual screen.
  external traa_rect rect;

  /// @brief The size of the source's icon.
  ///
  /// This is the size of the source's icon.
  external traa_size icon_size;

  /// @brief The size of the source's thumbnail.
  ///
  /// This is the size of the source's thumbnail.
  external traa_size thumbnail_size;

  /// @brief The title of the source.
  ///
  /// This is the title of the source.
  @ffi.Array.multi([256])
  external ffi.Array<ffi.Char> title;

  /// @brief The process path of the source.
  ///
  /// This is the process path of the source.
  @ffi.Array.multi([256])
  external ffi.Array<ffi.Char> process_path;

  /// @brief The data for the source's icon.
  ///
  /// This is the data for the source's icon.
  external ffi.Pointer<ffi.Uint8> icon_data;

  /// @brief The data for the source's thumbnail.
  ///
  /// This is the data for the source's thumbnail.
  external ffi.Pointer<ffi.Uint8> thumbnail_data;
}

/// @struct traa_rect
/// @brief Represents a rectangle in a 2D space.
///
/// The traa_rect struct contains the origin and size of a rectangle in a 2D space.
/// It is used to represent the position and dimensions of an object in a 2D space.
final class traa_rect extends ffi.Struct {
  @ffi.Int32()
  external int left;

  @ffi.Int32()
  external int top;

  @ffi.Int32()
  external int right;

  @ffi.Int32()
  external int bottom;
}
