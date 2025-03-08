import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:takip_deneme/navigation/main_navigation.dart';
import 'package:takip_deneme/pages/introduction/IntroScreen.dart';
import 'package:takip_deneme/providers/user_provider.dart'; // Intro ekranını eklediğinden emin ol

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Hive'ı başlat
    await Hive.initFlutter();

    // Kayıtlı verilerin saklanacağı kutuyu aç
    final box = await Hive.openBox('appData');

    // Uygulamanın ilk açılış olup olmadığını kontrol et
    bool isFirstLaunch = box.get('isFirstLaunch', defaultValue: true);

    runApp(MyApp(isFirstLaunch: isFirstLaunch));
  } catch (e) {
    print('Error during initialization: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 71, 6, 184)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: isFirstLaunch ? IntroScreen() : const MainNavigation(),
      ),
    );
  }
}
