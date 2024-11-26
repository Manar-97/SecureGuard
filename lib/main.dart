import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:secure_guard/src/features/authentication/screens/home/home.dart';
import 'package:secure_guard/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:secure_guard/src/utils/theme/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        SplashScreen.routeName: (_) => SplashScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}
