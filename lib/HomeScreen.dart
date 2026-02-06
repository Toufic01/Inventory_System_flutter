import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget{
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory App'),
      ),
      body: Center(child: Text("Hello Home", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),),
    );
  }
}