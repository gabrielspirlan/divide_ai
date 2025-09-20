import 'package:divide_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:divide_ai/components/group/select_members_group.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: const Center(
          child: SelectMembersGroup(),
        ),
      ),
    );
  }
}
