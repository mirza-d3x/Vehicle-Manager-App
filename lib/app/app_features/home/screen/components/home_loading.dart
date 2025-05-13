import 'package:flutter/material.dart';

class HomeLoadingComponent extends StatelessWidget {
  const HomeLoadingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
