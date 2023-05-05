import 'dart:async';

import 'package:client/widgets/authentication/common/bottom_text.dart';
import 'package:client/widgets/authentication/common/password_field.dart';
import 'package:client/widgets/authentication/common/submit_form_button.dart';
import 'package:client/widgets/authentication/signup_page.dart';
import 'package:client/widgets/journaling/journal_page.dart';

import 'package:flutter/material.dart';

import '../../services/api/auth_service.dart';
import 'common/email_field.dart';
import 'common/error_message.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // triggered when submitting form
  String _errorMessage = "";

  void onSubmittingForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      //_errorMessage = "";
    });

    final response = await AuthService.loginUser(
        _emailController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
      Navigator.of(context).pushReplacementNamed(JournalPage.route);
    } else if (response.status == 400 || response.status == 401) {
      setState(() {
        _errorMessage = response.message;
      });
    } else {
      const snackBar = SnackBar(
        content: Text(
          'Error submitting form. Please try again',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                            fontSize: 28.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    EmailField(emailController: _emailController),
                    const SizedBox(height: 20.0),
                    PasswordField(
                        passwordController: _passwordController,
                        hintText: 'Password',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20.0),
                    if (_errorMessage.isNotEmpty) ErrorMessage(_errorMessage),
                    SubmitFormButton(
                        isLoading: _isLoading,
                        onFormSubmit: onSubmittingForm,
                        text: 'Log in'),
                    const SizedBox(height: 20.0),
                    const BottomTextButton(
                        text: "Don't have an account? Sign Up",
                        route: SignUpPage.route)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
