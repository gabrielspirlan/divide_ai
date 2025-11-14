import 'package:divide_ai/models/data/user.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class UserCard extends StatelessWidget {
  final User _user;
  final VoidCallback onTap;

  UserCard(this._user, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          spacing: 12,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Theme.of(context).colorScheme.primary,
              ),
              padding: EdgeInsets.all(12),
              child: Icon(HugeIcons.strokeRoundedUser02, size: 32),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    _user.name,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    _user.email,
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedPencilEdit02,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                            size: 14,
                          ),
                          Text(
                            "Editar perfil",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onPrimaryFixed,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
