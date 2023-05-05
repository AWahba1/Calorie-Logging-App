import 'dart:async';

import 'package:client/services/api/auth_service.dart';
import 'package:client/widgets/authentication/common/bottom_text.dart';
import 'package:client/widgets/authentication/common/password_field.dart';
import 'package:client/widgets/authentication/common/submit_form_button.dart';
import 'package:client/widgets/authentication/login_page.dart';
import 'package:flutter/material.dart';

import 'common/email_field.dart';
import 'common/error_message.dart';

class SignUpPage extends StatefulWidget {
  static const route = '/signup';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false; // triggered when submitting form
  String _errorMessage = "";

  void onSubmittingForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      //_errorMessage="";
    });

    final response = await AuthService.registerUser(_nameController.text,
        _emailController.text.toLowerCase(), _passwordController.text);

    //print(isSuccessful);
    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
      Navigator.of(context).pushReplacementNamed(LoginPage.route);
    } else if (response.status == 400) {
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
        child: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       Color(0xFF0A192F),
          //       Color(0xFF172A45),
          //     ],
          //   ),
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create Account',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Your Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your name';
                      } else {
                        return null;
                      }
                    },
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
                  PasswordField(
                      passwordController: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        } else if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20.0),
                  if (_errorMessage.isNotEmpty) ErrorMessage(_errorMessage),
                  SubmitFormButton(
                      isLoading: _isLoading,
                      onFormSubmit: onSubmittingForm,
                      text: 'Sign Up'),
                  const SizedBox(height: 20.0),
                  const BottomTextButton(
                      text: 'Already have an account? Log in',
                      route: LoginPage.route)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
