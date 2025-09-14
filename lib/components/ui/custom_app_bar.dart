import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  final String? description;
  final Icon? icon;
  final VoidCallback? tapIcon;

  CustomAppBar(this._title, {this.description, this.icon, this.tapIcon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_title),
            if (description != null)
              Text(
                description!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white60,
                ),
              ),
          ],
        ),
      ),

      actions: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: tapIcon,
              icon: Icon(
                Icons.insert_chart_outlined_sharp,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
