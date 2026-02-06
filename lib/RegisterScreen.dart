import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class RegisterScreen extends StatelessWidget{
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final emailController = TextEditingController();

    // reference to "users" node
    final DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users');

    Future<void> onSubmit() async {

      final username = usernameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();


      if(username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
          ),
        );
        return;
      }
      if(password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        return;
      }

      if(password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 6 characters long'),
          ),
        );
        return;
      }

      try {

        final newUserRef = userRef.push();
        await newUserRef.set({
          'username': username,
          'email': email,
          'password': password,
          'createAt': ServerValue.timestamp,
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => const Homescreen()));

      }catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }


    }


    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFFEE8E8),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, // 👈 good for web & mobile
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Top title box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: const Color(0xFFE4E4E4),
                    ),
                    child: const Text(
                      'Inventory App',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  SizedBox(height: 40,),
                  _InputBox(hint: 'Username', controller: usernameController),
                  SizedBox(height: 20,),
                  _InputBox(hint: 'Email', controller: emailController),
                  SizedBox(height: 20,),
                  _InputBox(hint: 'Password', controller: passwordController),
                  SizedBox(height: 20,),
                  _InputBox(hint: 'Confirm Password', controller: confirmPasswordController),

                  const Spacer(), // 👈 better than spaceBetween

                  SizedBox(
                    height: 56,
                    width: double.infinity, // 👈 button fills width
                    child: ElevatedButton(
                      onPressed: () {

                        onSubmit();

                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}

class _InputBox extends StatelessWidget{

  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;

  const _InputBox({
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text
  });


  @override
  Widget build(BuildContext context) {
    bool isPassword = false;
    TextInputType finalKeyboardType = keyboardType;

    if (hint == 'Password' || hint == 'Confirm Password') {
      isPassword = true;
      finalKeyboardType = TextInputType.visiblePassword;
    }

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: finalKeyboardType,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }


}