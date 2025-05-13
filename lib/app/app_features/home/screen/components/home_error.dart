import 'package:flutter/material.dart';
import 'package:vehicle_manager/app/components/elevated_button.dart';

class HomeErrorComponent extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  const HomeErrorComponent(
      {required this.errorMessage, required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          CustomElevatedButton(onPressed: onRetry, child: Text("Retry")),
        ],
      ),
    );
  }
}
