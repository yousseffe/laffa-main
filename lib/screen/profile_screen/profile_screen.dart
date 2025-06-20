import 'package:ecommerce_laffa/screen/home_screen.dart';

import '../../utility/animation/open_container_wrapper.dart';
import '../../utility/extensions.dart';
import '../../widget/navigation_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/app_color.dart';
import 'package:provider/provider.dart';
import '../../l10n/locale_provider.dart';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        var localizations = AppLocalizations.of(context);
        const TextStyle linkStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
        const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

        // Read the name from storage
        String name = storage.read('name') ?? 'No Name';

        return Scaffold(
          appBar: AppBar(
            title: Text(
              localizations.translate('myAccount'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.darkOrange),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(
                height: 200,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                    'assets/images/profile_pic.png',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  name,
                  style: titleStyle,
                ),
              ),
              const SizedBox(height: 40),
              OpenContainerWrapper(
                nextScreen: const LanguageSelectionPage(),
                child: NavigationTile(
                  icon: Icons.language,
                  title: localizations.translate('changeLanguage'),
                ),
              ),
              const SizedBox(height: 20),
              OpenContainerWrapper(
                nextScreen: const ManagePersonalInformationPage(),
                child: NavigationTile(
                  icon: Icons.person,
                  title: localizations.translate('managePersonalInfo'),
                ),
              ),
              // const SizedBox(height: 20),
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColor.darkOrange,
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              //     ),
              //     onPressed: () {
              //       Get.offAll(const LoginScreen());
              //     },
              //     child: Text(
              //       localizations.translate('logout'),
              //       style: const TextStyle(fontSize: 18)
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

class ManagePersonalInformationPage extends StatelessWidget {
  const ManagePersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final GetStorage storage = GetStorage();

    // Load initial data from storage
    nameController.text = storage.read('name') ?? '';
    phoneController.text = storage.read('phoneNumber') ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('managePersonalInfo')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: localizations.translate('name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: localizations.translate('phoneNumber'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save changes to storage
                storage.write('name', nameController.text);
                storage.write('phoneNumber', phoneController.text);
                Get.back();
              },
              child: Text(localizations.translate('saveChanges')),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    final localeProvider = Provider.of<LocaleProvider>(context);
    final GetStorage storage = GetStorage();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('selectLanguage')),
      ),
      body: ListView(
        children: [
          // ListTile(
          //   title: Text(localizations.translate('english')),
          //   trailing: localeProvider.locale.languageCode == 'en'
          //       ? const Icon(Icons.check, color: AppColor.darkOrange)
          //       : null,
          //   onTap: () {
          //     localeProvider.setLocale(const Locale('en'));
          //     storage.write('language', 'English');
          //     Get.back();
          //   },
          // ),
          ListTile(
            title: Text(localizations.translate('arabic')),
            trailing: localeProvider.locale.languageCode == 'ar'
                ? const Icon(Icons.check, color: AppColor.darkOrange)
                : null,
            onTap: () {
              localeProvider.setLocale(const Locale('ar'));
              storage.write('language', 'العربيه');
              Get.back();
            },
          ),
          ListTile(
            title: Text(localizations.translate('french')),
            trailing: localeProvider.locale.languageCode == 'fr'
                ? const Icon(Icons.check, color: AppColor.darkOrange)
                : null,
            onTap: () {
              localeProvider.setLocale(const Locale('fr'));
              storage.write('language', 'Français');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
