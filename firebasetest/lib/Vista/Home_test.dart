import "package:flutter/material.dart";

class hometest extends StatelessWidget {
  const hometest({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          title: const Text('Test Firebase'),
        ),
        body: const Padding(padding: EdgeInsets.symmetric(horizontal: 10),      
        ),
      );
  }
  
}

