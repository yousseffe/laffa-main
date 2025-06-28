import 'package:ecommerce_laffa/l10n/locale_provider.dart';
import 'package:ecommerce_laffa/utility/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'core/data/data_provider.dart';
import 'screen/home_screen.dart';
import 'screen/product_by_category_screen/provider/product_by_category_provider.dart';
import 'screen/product_details_screen/provider/product_detail_provider.dart';
import 'screen/product_favorite_screen/provider/favorite_provider.dart';
import 'screen/profile_screen/provider/profile_provider.dart';
import 'utility/extensions.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final storage = GetStorage();

  final String? storedLanguage = storage.read('language');

  // var cart = FlutterCart();
  OneSignal.initialize("66c983db-74cf-4657-882d-b3cf579f6691");
  OneSignal.Notifications.requestPermission(true);
  // await cart.initializeCart(isPersistenceSupportEnabled: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                ProductByCategoryProvider(context.dataProvider)),
        ChangeNotifierProvider(
            create: (context) => ProductDetailProvider(context.dataProvider)),
        ChangeNotifierProvider(
            create: (context) => FavoriteProvider(context.dataProvider)),
        ChangeNotifierProvider(
            create: (context) => ProfileProvider(context.dataProvider)),
        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return GetMaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      locale: localeProvider.locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // builder: (context, child) {
      //   return const SplashScreen();
      //   // return Directionality(
      //   //   textDirection:
      //   //       localeProvider.isRTL ? TextDirection.rtl : TextDirection.ltr,
      //   //   child: child!,
      //   // );
      // },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // 3 seconds delay

    if (!mounted) return;

    final bool hasLanguage = storage.read('language') != null;

    Get.off(
      () => hasLanguage ? HomeScreen() : const LanguageSelectionScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 260,
              child: Image.asset("assets/images/laffa_logo.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              'لأنك تشادية تستحقين الأفضل',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 5),
            const Text(
              'Parce que tu es tchadien, tu mérites le meilleur',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Language',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF002664), // Blue from Chad flag
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLanguageButton(
                'العربيه',
                Colors.white,
                Colors.green,
                context,
                () async {
                  final storage = GetStorage();
                  localeProvider.setLocale(Locale('ar'));
                  storage.write('language', 'ar');
                  storage.write('isSetupComplete', true);
                  Get.off(() => HomeScreen());
                },
              ),
              const SizedBox(height: 20),
              // _buildLanguageButton(
              //   'English',
              //   Colors.white,
              //   Colors.blue,
              //   context,
              //   () async {
              //     final storage = GetStorage();
              //      localeProvider.setLocale(const Locale('en'));
              //     storage.write('language', 'English');
              //     storage.write('isSetupComplete', true);
              //     Get.off(() => UserInfoScreen(language: 'English'));
              //   },
              // ),
              const SizedBox(height: 20),
              _buildLanguageButton(
                'Français',
                Colors.white,
                Colors.orange,
                context,
                () async {
                  final storage = GetStorage();
                   localeProvider.setLocale(const Locale('fr'));
                  storage.write('language', 'fr');
                  storage.write('isSetupComplete', true);
                  Get.off(() => HomeScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    String text,
    Color textColor,
    Color backgroundColor,
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
