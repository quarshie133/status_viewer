import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:status_viewer/src/app.dart';

import 'package:status_viewer/src/data/repository/photo_repo.dart';
import 'package:status_viewer/src/data/repository/video_repo.dart';
import 'package:status_viewer/src/screens/photo_screen.dart';
import 'package:status_viewer/src/screens/video_screen.dart';
import 'package:status_viewer/src/utils/add_manager.dart';
import 'package:status_viewer/src/utils/cache_svg_images.dart';
import 'package:status_viewer/src/utils/theme.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final PhotoRepository photoRepository = PhotoRepository();
  final VideoRepository videoRepository = VideoRepository();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitDown]);

  // ##################### uncomment for Admob ########################

  runApp(MyApp(
    photoRepository: photoRepository,
    videoRepository: videoRepository,
  ));
}

class MyApp extends StatefulWidget {
  final PhotoRepository photoRepository;
  final VideoRepository videoRepository;

  const MyApp(
      {super.key,
      required this.photoRepository,
      required this.videoRepository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _storagePermissionCheck;
  Future<int>? _storagePermissionChecker;

  int? androidSDK;

  Future<int> _loadPermission() async {
    //Get phone SDK version first inorder to request correct permissions.

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    //
    if (androidSDK! >= 30) {
      //Check first if we already have the permissions
      final _currentStatusManaged =
          await Permission.manageExternalStorage.status;
      if (_currentStatusManaged.isGranted) {
        //Update
        return 1;
      } else {
        return 0;
      }
    } else {
      //For older phones simply request the typical storage permissions
      //Check first if we already have the permissions
      final _currentStatusStorage = await Permission.storage.status;
      if (_currentStatusStorage.isGranted) {
        //Update provider
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      //request management permissions for android 11 and higher devices
      final _requestStatusManaged =
          await Permission.manageExternalStorage.request();
      //Update Provider model
      if (_requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _requestStatusStorage = await Permission.storage.request();
      //Update provider model
      if (_requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    /// PermissionStatus result = await
    /// SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    final result = await [Permission.storage].request();
    setState(() {});
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await _loadPermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 672),
        builder: (context, _) {
          return MaterialApp(
            title: 'Status Viewer',
            theme: basicTheme(),
            debugShowCheckedModeBanner: false,
            home: FutureBuilder(
              future: _storagePermissionChecker,
              builder: (context, status) {
                if (status.connectionState == ConnectionState.done) {
                  if (status.hasData) {
                    if (status.data == 1) {
                      return const Home();
                    } else {
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(ItemSize.radius(20)),
                                child: Text(
                                  "Read/Write Permission Required",
                                  style: TextStyle(
                                      fontSize: ItemSize.fontSize(20)),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(ItemSize.radius(15)),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textStyle: TextStyle(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ItemSize.radius(50))),
                                ),
                                onPressed: () {
                                  _storagePermissionChecker =
                                      requestPermission();
                                  setState(() {});
                                },
                                child: Text(
                                  "Allow read/write Permission",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ItemSize.fontSize(20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Scaffold(
                      body: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.lightBlue[100]!,
                            Colors.lightBlue[200]!,
                            Colors.lightBlue[300]!,
                            Colors.lightBlue[200]!,
                            Colors.lightBlue[100]!,
                          ],
                        )),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(ItemSize.radius(20)),
                                child: Text(
                                  "Something went wrong.. Please uninstall and Install Again.",
                                  style: TextStyle(
                                      fontSize: ItemSize.fontSize(20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            routes: <String, WidgetBuilder>{
              "/home": (BuildContext context) => Home(),
              "/photos": (BuildContext context) => PhotoView(),
              "/videos": (BuildContext context) => VideoListView(),
              // "/aboutus": (BuildContext context) => AboutScreen(),
            },
          );
        });
  }
}
