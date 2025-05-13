import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? Function(String? value)? validator;
  final bool? enabled;

  const CustomTextFormField({
    this.controller,
    this.focusNode,
    this.labelText,
    this.validator,
    this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      minLines: 1,
      maxLines: 5,
      maxLength: 50,
      validator: validator,
      enabled: enabled,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
