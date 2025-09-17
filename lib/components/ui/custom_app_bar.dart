import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  final String? description;
  final IconData? icon;
  final VoidCallback? tapIcon;

  CustomAppBar(this._title, {this.description, this.icon, this.tapIcon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 30,
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
          IconButton(
            onPressed: tapIcon,
            icon: Icon(icon!, color: Colors.white),
          ),
      ],
      automaticallyImplyLeading: true,
      leading: Navigator.of(context).canPop()
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back),
              ),
            )
          : null,
      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
