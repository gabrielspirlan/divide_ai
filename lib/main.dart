import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/theme/AppTheme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: Scaffold(appBar: AppBar(title: Text("DivideAi")), body: GroupCard(),),
    );
  }
}
