import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../core/data/cart_provider.dart';
import '../core/data/data_provider.dart';
import '../core/data/region_provider.dart';
import '../models/region.dart';
import '../utility/app_color.dart';
import 'home_screen.dart';

class RegionSelectionScreen extends StatelessWidget {
  final bool isChangingRegion;

  const RegionSelectionScreen({super.key, this.isChangingRegion = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isChangingRegion
          ? AppBar(
              title: const Text('اختر منطقتك', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            if (dataProvider.isLoadingRegions && dataProvider.regions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.location_on, size: 60, color: AppColor.darkOrange),
                const SizedBox(height: 16),
                const Text(
                  'اختر منطقتك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'الأسعار تختلف حسب منطقتك لأنها تشمل التوصيل',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: dataProvider.regions.length,
                    itemBuilder: (context, index) {
                      final Region region = dataProvider.regions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        child: ListTile(
                          title: Text(region.name ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            context.read<RegionProvider>().setRegion(region);
                            context.read<CartProvider>().updateDeliveryFee(region.deliveryFee ?? 0);
                            if (isChangingRegion) {
                              Navigator.of(context).pop();
                            } else {
                              Get.offAll(() => const HomeScreen(), transition: Transition.fadeIn);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
