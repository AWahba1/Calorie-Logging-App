import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EmailField extends StatefulWidget {
  // const EmailField({Key? key}) : super(key: key);

  final TextEditingController emailController;

  const EmailField({required this.emailController});
  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.emailController,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter an email';
        } else if (!EmailValidator.validate(value)) {
          return 'Enter a valid email';
        } else {
          return null;
        }
      },
    );
  }
}
