import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:file_picker/file_picker.dart';

import 'package:traa_plugin/traa_plugin.dart';
import 'package:traa_plugin/traa_plugin_bindings_generated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize TraaPlugin
    var config = calloc<traa_config>();
    config.ref.userdata = nullptr;
    config.ref.log_config.level = traa_log_level.TRAA_LOG_LEVEL_TRACE;
    config.ref.event_handler.on_error = nullptr;
    config.ref.event_handler.on_device_event = nullptr;

    TraaPlugin.init(config);

    // free the allocated memory
    calloc.free(config);
  }

  @override
  void dispose() {
    TraaPlugin.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _recording = false;
  bool _exporting = false;
  bool _showingSources = false;
  ScreenRecorderController pageRecorder = ScreenRecorderController();
  bool get canExport => pageRecorder.exporter.hasFrames;

  @override
  Widget build(BuildContext context) {
    // 获取窗口尺寸
    final size = MediaQuery.of(context).size;

    return ScreenRecorder(
        controller: pageRecorder,
        width: size.width,
        height: size.height,
        child: Scaffold(
          body: _showingSources
              ? const ScreenSourcesPage()
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (_exporting)
                          const Center(child: CircularProgressIndicator())
                        else ...[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showingSources = true;
                              });
                            },
                            child: const Text('Show Screen Sources'),
                          ),
                        ],
                      ]),
                ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canExport && !_exporting) ...[
                const SizedBox(width: 16),
                ExportButton(
                  onPressed: () async {
                    setState(() {
                      _exporting = true;
                    });
                    var gif = await pageRecorder.exporter.exportGif();
                    if (gif == null) {
                      throw Exception('Failed to export GIF');
                    }
                    setState(() => _exporting = false);
                    if (!mounted) return;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Recording Preview'),
                          content: Image.memory(Uint8List.fromList(gif)),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // 生成默认文件名（时间戳）
                                final timestamp = DateTime.now()
                                    .toIso8601String()
                                    .replaceAll(':', '-')
                                    .replaceAll('.', '-');
                                final defaultFileName =
                                    'recording_$timestamp.gif';

                                // 打开文件保存对话框
                                String? outputFile =
                                    await FilePicker.platform.saveFile(
                                  dialogTitle: 'Save recording as GIF',
                                  fileName: defaultFileName,
                                  type: FileType.custom,
                                  allowedExtensions: ['gif'],
                                );

                                if (outputFile != null) {
                                  // 确保文件扩展名正确
                                  if (!outputFile
                                      .toLowerCase()
                                      .endsWith('.gif')) {
                                    outputFile = '$outputFile.gif';
                                  }

                                  // 保存文件
                                  await File(outputFile).writeAsBytes(gif);

                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Saved to: $outputFile'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Save'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  pageRecorder.exporter.clear();
                                });
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
              const SizedBox(width: 16),
              RecordButton(
                recording: _recording,
                onPressed: () {
                  setState(() {
                    _recording = !_recording;
                    if (_recording) {
                      pageRecorder.start();
                    } else {
                      pageRecorder.stop();
                    }
                  });
                },
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }
}

class ScreenSourcesPage extends StatefulWidget {
  const ScreenSourcesPage({super.key});

  @override
  State<ScreenSourcesPage> createState() => _ScreenSourcesPageState();
}

class _ScreenSourcesPageState extends State<ScreenSourcesPage> {
  String? _selectedProcessPath;
  List<ScreenSourceInfo>? _sources;
  bool _isLoading = true;
  bool _isRefreshing = false;
  ScreenSourceInfo? _selectedSource;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _sources = await _loadScreenSources();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      _sources = await _loadScreenSources();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 680,
        height: 540,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Screen Source',
                    style: TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    final state =
                        context.findAncestorStateOfType<_MyHomePageState>();
                    state?.setState(() {
                      state._showingSources = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const SizedBox()
            else if (_sources != null)
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FilterChip(
                            selected: _selectedProcessPath == 'DISPLAYS',
                            showCheckmark: false,
                            label: const SizedBox(
                              width: 24,
                              height: 24,
                              child: Icon(Icons.desktop_windows, size: 24),
                            ),
                            onSelected: (_) => _onFilterChanged(
                                _selectedProcessPath == 'DISPLAYS'
                                    ? null
                                    : 'DISPLAYS'),
                            labelStyle: const TextStyle(fontSize: 0),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide.none,
                          ),
                          const SizedBox(width: 8),
                          ..._getProcessGroups().map((group) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  selected:
                                      _selectedProcessPath == group.processPath,
                                  showCheckmark: false,
                                  label: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: FutureBuilder<ui.Image>(
                                      future: _createImageFromPixels(
                                        group.iconData,
                                        group.iconSize.width.toInt(),
                                        group.iconSize.height.toInt(),
                                      ),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Icon(
                                            Icons.apps,
                                            size: 24,
                                            color: Colors.grey[600],
                                          );
                                        }
                                        return RawImage(
                                          image: snapshot.data,
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                  ),
                                  tooltip: group.processName,
                                  onSelected: (_) => _onFilterChanged(
                                      _selectedProcessPath == group.processPath
                                          ? null
                                          : group.processPath),
                                  labelStyle: const TextStyle(fontSize: 0),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide.none,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: _isRefreshing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh, size: 24),
                        onPressed: _isRefreshing ? null : _refreshData,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _sources == null || _sources!.isEmpty
                      ? const Center(child: Text('No screen sources available'))
                      : _buildGridView(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _selectedSource != null
                    ? () => Navigator.of(context).pop(_selectedSource)
                    : null,
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProcessGroup> _getProcessGroups() {
    final groups = <String, ProcessGroup>{};

    for (var source in _sources!) {
      if (source.isWindow) {
        if (!groups.containsKey(source.processPath)) {
          groups[source.processPath] = ProcessGroup(
            processName: source.title.split(' - ').last,
            processPath: source.processPath,
            iconData: source.iconData,
            iconSize: source.iconSize,
          );
        }
      }
    }

    return groups.values.toList();
  }

  Widget _buildGridView() {
    var filteredSources = _sources!;

    if (_selectedProcessPath != null) {
      if (_selectedProcessPath == 'DISPLAYS') {
        filteredSources =
            filteredSources.where((source) => !source.isWindow).toList();
      } else {
        filteredSources = filteredSources
            .where((source) => source.processPath == _selectedProcessPath)
            .toList();
      }
      if (_selectedSource != null &&
          !filteredSources.contains(_selectedSource)) {
        setState(() => _selectedSource = null);
      }
    }

    if (filteredSources.isEmpty) {
      return const Center(child: Text('No screen sources available'));
    }

    filteredSources.sort((a, b) {
      if (a.isWindow == b.isWindow) return 0;
      return a.isWindow ? 1 : -1;
    });

    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2, // 调整宽高比
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredSources.length,
      itemBuilder: (context, index) {
        final source = filteredSources[index];
        return Card(
          elevation: 4,
          color: _selectedSource?.id == source.id
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: () => setState(() {
              _selectedSource =
                  _selectedSource?.id == source.id ? null : source;
            }),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FutureBuilder<ui.Image>(
                      future: _createImageFromPixels(
                        source.thumbnailData,
                        source.thumbnailSize.width.toInt(),
                        source.thumbnailSize.height.toInt(),
                      ),
                      builder: (context, imageSnapshot) {
                        if (!imageSnapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return RawImage(
                          image: imageSnapshot.data,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: source.isWindow
                            ? FutureBuilder<ui.Image>(
                                future: _createImageFromPixels(
                                  source.iconData,
                                  source.iconSize.width.toInt(),
                                  source.iconSize.height.toInt(),
                                ),
                                builder: (context, iconSnapshot) {
                                  if (!iconSnapshot.hasData) {
                                    return Icon(
                                      Icons.apps,
                                      size: 24,
                                      color: Colors.grey[600],
                                    );
                                  }
                                  return RawImage(
                                    image: iconSnapshot.data,
                                    fit: BoxFit.contain,
                                  );
                                },
                              )
                            : Icon(
                                Icons.desktop_windows,
                                size: 24,
                                color: Colors.grey[600],
                              ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Tooltip(
                          message: source.title,
                          child: Text(
                            source.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onFilterChanged(String? newProcessPath) {
    setState(() {
      _selectedProcessPath = newProcessPath;
      _selectedSource = null;
    });
  }
}

Future<List<ScreenSourceInfo>> _loadScreenSources() async {
  final iconSize = calloc<traa_size>();
  final thumbnailSize = calloc<traa_size>();
  final infos = calloc<Pointer<traa_screen_source_info>>();
  final count = calloc<Int>();

  try {
    iconSize.ref.width = 48;
    iconSize.ref.height = 48;
    thumbnailSize.ref.width = 320;
    thumbnailSize.ref.height = 320;

    await TraaPlugin.enumScreenSourceInfo(
      iconSize.ref,
      thumbnailSize.ref,
      0,
      infos,
      count,
    );

    final sources = <ScreenSourceInfo>[];
    final infoArray = infos.value;

    for (var i = 0; i < count.value; i++) {
      var info = infoArray[i];

      final iconWidth = info.icon_size.width;
      final iconHeight = info.icon_size.height;
      final thumbnailWidth = info.thumbnail_size.width;
      final thumbnailHeight = info.thumbnail_size.height;

      // Store raw pixel data
      final iconBytes = Uint8List.fromList(
          info.icon_data.cast<Uint8>().asTypedList(iconWidth * iconHeight * 4));
      final thumbnailBytes = Uint8List.fromList(info.thumbnail_data
          .cast<Uint8>()
          .asTypedList(thumbnailWidth * thumbnailHeight * 4));

      sources.add(ScreenSourceInfo(
        id: info.id,
        title: info.title.toDartString(),
        processPath: info.process_path.toDartString(),
        isWindow: info.is_window,
        iconData: iconBytes,
        iconSize: ui.Size(iconWidth.toDouble(), iconHeight.toDouble()),
        thumbnailData: thumbnailBytes,
        thumbnailSize:
            ui.Size(thumbnailWidth.toDouble(), thumbnailHeight.toDouble()),
      ));
    }

    // Sort the sources: non-windows first
    sources.sort((a, b) {
      if (a.isWindow == b.isWindow) return 0;
      return a.isWindow ? 1 : -1;
    });

    TraaPlugin.freeScreenSourceInfo(infos.value, count.value);

    return sources;
  } finally {
    calloc.free(iconSize);
    calloc.free(thumbnailSize);
    calloc.free(infos);
    calloc.free(count);
  }
}

Future<ui.Image> _createImageFromPixels(
    Uint8List pixels, int width, int height) async {
  final completer = Completer<ui.Image>();

  // Convert BGRA to RGBA
  final rgbaPixels = Uint8List(pixels.length);
  for (var i = 0; i < pixels.length; i += 4) {
    rgbaPixels[i] = pixels[i]; // R
    rgbaPixels[i + 1] = pixels[i + 1]; // G = G
    rgbaPixels[i + 2] = pixels[i + 2]; // B
    rgbaPixels[i + 3] = pixels[i + 3]; // A = A
  }

  ui.decodeImageFromPixels(
    rgbaPixels,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );

  return completer.future;
}

class ScreenSourceInfo {
  final int id;
  final String title;
  final String processPath;
  final bool isWindow;
  final Uint8List iconData;
  final ui.Size iconSize;
  final Uint8List thumbnailData;
  final ui.Size thumbnailSize;

  ScreenSourceInfo({
    required this.id,
    required this.title,
    required this.processPath,
    required this.isWindow,
    required this.iconData,
    required this.iconSize,
    required this.thumbnailData,
    required this.thumbnailSize,
  });
}

class ProcessGroup {
  final String processName;
  final String processPath;
  final Uint8List iconData;
  final ui.Size iconSize;

  ProcessGroup({
    required this.processName,
    required this.processPath,
    required this.iconData,
    required this.iconSize,
  });
}

class RecordButton extends StatefulWidget {
  final bool recording;
  final VoidCallback onPressed;

  const RecordButton({
    super.key,
    required this.recording,
    required this.onPressed,
  });

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.recording)
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
              );
            },
          ),
        FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: widget.recording
              ? Colors.red
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            widget.recording ? Icons.stop_rounded : Icons.fiber_manual_record,
            color: widget.recording
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class ExportButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ExportButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            );
          },
        ),
        FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.save_alt,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
