import 'package:flutter/material.dart';

class inicio extends StatefulWidget {

    const inicio({super.key});

  @override
  State<inicio> createState() => _inicio();
}

class _inicio extends State<inicio>{

    @override
    Widget build(BuildContext context) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' Bienvenido')
            ],
          ),
        );
    }
}