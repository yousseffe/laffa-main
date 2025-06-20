import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class CustomBottomNavyBar extends StatefulWidget {
  const CustomBottomNavyBar({super.key});

  @override
  _CustomBottomNavyBarState createState() => _CustomBottomNavyBarState();
}

class _CustomBottomNavyBarState extends State<CustomBottomNavyBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      itemCornerRadius: 10,
      selectedIndex: selectedIndex,
      items: [
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text('Home'),
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.favorite),
          title: const Text('Favorites'),
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: const Text('Cart'),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
        ),
      ],
      onItemSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}