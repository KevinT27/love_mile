import 'package:flutter/material.dart';

//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:love_mile/services/network_service.dart';


//Services
import '../services/navigation_service.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';
import 'package:love_mile/services/location_service.dart';

// Widgets
import '../widgets/logo_dart.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({
    required Key key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then(
          (_) {
        _setup().then(
              (_) => widget.onInitializationComplete(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chatify',
      home: Scaffold(
        body: Center(
          child: Logo(),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(
      NavigationService(),
    );
    GetIt.instance.registerSingleton<MediaService>(
      MediaService(),
    );
    GetIt.instance.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );
    GetIt.instance.registerSingleton<DatabaseService>(
      DatabaseService(),
    );
    GetIt.instance.registerSingleton<LocationService>(
        LocationService()
    );

    GetIt.instance.registerSingleton<NetworkService>(
        NetworkService()
    );
  }
}
