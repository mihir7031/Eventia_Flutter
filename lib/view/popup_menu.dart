// popup_menu.dart
import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  final void Function(String) onMenuOptionSelected;

  CustomPopupMenu({required this.onMenuOptionSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: onMenuOptionSelected,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'Settings',
            child: Text('Settings'),
          ),
          PopupMenuItem<String>(
            value: 'Logout',
            child: Text('Logout'),
          ),
          // Add more menu items as needed
        ];
      },
    );
  }
}
