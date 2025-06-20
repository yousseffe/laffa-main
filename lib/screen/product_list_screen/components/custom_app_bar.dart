import 'package:ecommerce_laffa/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../widget/custom_search_bar.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70, // Adjust the width as needed
              height: 70, // Adjust the height as needed
              child: Image.asset("assets/images/laffa_logo.png"),
            ),
            Expanded(
              child: CustomSearchBar(
                controller: TextEditingController(),
                onChanged: (val) {
                  context.dataProvider.filterProduct(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
