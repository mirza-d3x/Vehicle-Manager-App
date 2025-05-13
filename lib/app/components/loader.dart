import 'package:flutter/material.dart';

class CustomProgressIndicator {
  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 40.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void removeLoader(BuildContext context) {
    Navigator.of(context).pop();
  }
}
