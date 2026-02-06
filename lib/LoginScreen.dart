import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/HomeScreen.dart';
import 'package:inventory_system/RegisterScreen.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {

    final useremilController = TextEditingController();
    final passwordController = TextEditingController();


    Future<void> onLogin() async{

      final email = useremilController.text.trim();
      final password = passwordController.text.trim();

      if(email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
          ),
        );
        return;
      }

      try {

        final auth = FirebaseAuth.instance;

        await auth.signInWithEmailAndPassword(email: email, password: password);

        useremilController.clear();
        passwordController.clear();

        Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));

      }on FirebaseAuthException catch (e) {
        String message = 'Login failed';
        if (e.code == 'wrong-password') {
          message = 'Incorrect password';
        } else if (e.code == 'user-not-found') {
          message = 'No user found for that email';
        } else if (e.code == 'invalid-email') {
          message = 'Email is not valid';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
      }
    }


    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 420),
          child: Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Color(0xffeed2d2),
            border: Border.all(color: Colors.black87,width: 2),),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87,width: 2),
                    color: Color(0xffe4e4e4),
                  ),
                  child: Text('Inventory App', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                  ),

                SizedBox(height: 40,),
                _inputBox(hint: 'Enter User Email',controller: useremilController),
                SizedBox(height: 20,),
                _inputBox(hint: 'Enter Password',controller: passwordController),

                const Spacer(),

                SizedBox(
                  child: Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: const Text(
                              "Don't have account? Register here",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )

                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,          // button color
                      foregroundColor: Colors.white,        // text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28), // pill shape
                      ),
                      padding: EdgeInsets.zero,             // so it matches height exactly
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                )

              ],
            ),
          ),
          ),
        )
      ),
    );
  }
}


class _inputBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const _inputBox({
    required this.hint,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPassword = hint == 'Enter Password';
    final TextInputType finalKeyboardType =
    hint == 'Enter Password'
        ? TextInputType.visiblePassword
        : hint == 'Enter User Email'
        ? TextInputType.emailAddress
        : TextInputType.text;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: isPassword,        // use isPassword here
        keyboardType: finalKeyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
