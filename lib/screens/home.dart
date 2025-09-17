import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Olá Luiz",
        description: "Gerencie seus grupos de despesas",
        icon: HugeIcons.strokeRoundedSettings01,
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return GroupCard(group);
        },
      ),
    );
  }
}
