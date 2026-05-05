import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_logger.dart';

class GamePlayPage extends StatefulWidget {
  final String linkUrl;
  final String title;
  final String token;
  const GamePlayPage({
    super.key,
    required this.linkUrl,
    required this.title,
    required this.token,
  });

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  InAppWebViewController? webViewController;
  double progress = 0;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Request permissions untuk camera & microphone
  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !canGoBack,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Cek apakah bisa back
        bool canNavigateBack = await webViewController?.canGoBack() ?? false;

        if (canNavigateBack) {
          // Back di WebView
          await webViewController?.goBack();
        } else {
          // Keluar dari screen
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: SafeArea(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(widget.title, style: const TextStyle(fontSize: 16)),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.refresh),
        //       onPressed: () {
        //         webViewController?.reload();
        //       },
        //     ),
        //   ],
        // ),
        child: Column(
          children: [
            // Progress bar
            if (progress < 1.0) LinearProgressIndicator(value: progress),

            // WebView
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.linkUrl),
                  headers: {"Authorization": "Bearer ${widget.token}"},
                ),

                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  mediaPlaybackRequiresUserGesture: false,

                  // PENTING: Setting untuk camera/media
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,

                  // Android
                  useHybridComposition: true,

                  // iOS
                  allowsInlineMediaPlayback: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    progress = 0;
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    progress = 1.0;
                  });

                  // Update status canGoBack
                  bool canNavigateBack = await controller.canGoBack();
                  setState(() {
                    canGoBack = canNavigateBack;
                  });
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },

                // Update canGoBack setiap kali navigasi terjadi
                onUpdateVisitedHistory:
                    (controller, url, androidIsReload) async {
                      bool canNavigateBack = await controller.canGoBack();
                      setState(() {
                        canGoBack = canNavigateBack;
                      });
                    },

                // HANDLER UNTUK CAMERA PERMISSION
                onPermissionRequest: (controller, request) async {
                  AppLogger.debug('Permission diminta: ${request.resources}');

                  // Cek camera permission
                  if (request.resources.contains(
                    PermissionResourceType.CAMERA,
                  )) {
                    var status = await Permission.camera.status;
                    if (!status.isGranted) {
                      status = await Permission.camera.request();
                    }

                    if (!status.isGranted) {
                      _showPermissionDeniedDialog('Kamera');
                      return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.DENY,
                      );
                    }
                  }

                  // Cek microphone permission
                  if (request.resources.contains(
                    PermissionResourceType.MICROPHONE,
                  )) {
                    var status = await Permission.microphone.status;
                    if (!status.isGranted) {
                      status = await Permission.microphone.request();
                    }

                    if (!status.isGranted) {
                      _showPermissionDeniedDialog('Mikrofon');
                      return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.DENY,
                      );
                    }
                  }

                  // Grant permission
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },

                onReceivedError: (controller, request, error) {
                  AppLogger.debug('Error: ${error.description}');
                },

                onConsoleMessage: (controller, consoleMessage) {
                  AppLogger.debug('Console: ${consoleMessage.message}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog jika permission ditolak
  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${AppStrings.get(AppStrings.commonKeyPermissionRequired)} $permissionName"),
        content: Text(
          "${AppStrings.get(AppStrings.commonKeyPermissionMessage)} ($permissionName)",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get(AppStrings.commonKeyCancel)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(AppStrings.get(AppStrings.commonKeyOpenSettings)),
          ),
        ],
      ),
    );
  }
}
