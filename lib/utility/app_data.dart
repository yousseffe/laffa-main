import 'package:flutter/material.dart';

import 'bottom_navy_bar_item.dart';


class AppData {
  const AppData._();


  static List<Color> randomColors = [
    const Color(0xFFFCE4EC),
    const Color(0xFFF3E5F5),
    const Color(0xFFEDE7F6),
    const Color(0xFFE3F2FD),
    const Color(0xFFE0F2F1),
    const Color(0xFFF1F8E9),
    const Color(0xFFFFF8E1),
    const Color(0xFFECEFF1),
  ];


  static List<Color> randomPosterBgColors = [
    const Color(0xFFE70D56),
    const Color(0xFF9006A4),
    const Color(0xFF137C0B),
    const Color(0xFF0F2EDE),
    const Color(0xFFECBE23),
    const Color(0xFFA60FF1),
    const Color(0xFF0AE5CF),
    const Color(0xFFE518D1),
  ];
  static const List<Color> randomPosterBgColors2 = [
    Color(0xFFFFC1E3), // Light Pink
    Color(0xFFFFE4E1), // Misty Rose
    Color(0xFFFFB6C1), // Light Pink
    Color(0xFFFFDAB9), // Peach Puff
    Color(0xFFFFEFD5), // Papaya Whip
    Color(0xFFFADADD), // Lavender Blush
    Color(0xFFFFE4B5), // Moccasin
    Color(0xFFFFD700), // Gold
    Color(0xFFFF69B4), // Hot Pink
    Color(0xFFFFA07A), // Light Salmon
  ];
  static List<BottomNavyBarItem> bottomNavyBarItems = [
    const BottomNavyBarItem(
      "Home",
      Icon(Icons.home),
      Color(0xFFFF69B4),
    ),
    const BottomNavyBarItem(
      "Favorite",
      Icon(Icons.favorite),
      Color(0xFFFF69B4),
    ),
    
    const BottomNavyBarItem(
      "Profile",
      Icon(Icons.person),
      Color(0xFFFF69B4),
    ),
  ];


  
}
