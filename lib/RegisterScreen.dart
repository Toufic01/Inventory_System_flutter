import 'package:firebase_auth/firebase_auth.dart';
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

        final credintial = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        final uid = credintial.user!.uid;

        await userRef.child(uid).set({
          'username': username,
          'email': email,
          'password': password,
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
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, // 👈 good for web & mobile
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFEED2D2),
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
                  _InputBox(hint: 'Enter Username', controller: usernameController),
                  SizedBox(height: 20,),
                  _InputBox(hint: 'Enter your email', controller: emailController),
                  SizedBox(height: 20,),
                  _InputBox(hint: 'Enter Password', controller: passwordController, obscure: true, keyboardType: TextInputType.visiblePassword),
                  SizedBox(height: 20,),
                  _InputBox(hint: 'Confirm Password', controller: confirmPasswordController, obscure: true, keyboardType: TextInputType.visiblePassword),

                  const Spacer(), // 👈 better than spaceBetween

                  SizedBox(
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text("Already have account!! Login Here!",
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),


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

class _InputBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;

  const _InputBox({
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}