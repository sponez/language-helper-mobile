import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/services/native_bridge.dart';
import 'src/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the native bridge
  final nativeBridge = NativeBridge();
  await nativeBridge.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<NativeBridge>.value(value: nativeBridge),
      ],
      child: const LanguageHelperApp(),
    ),
  );
}

class LanguageHelperApp extends StatelessWidget {
  const LanguageHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
