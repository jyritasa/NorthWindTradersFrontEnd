import 'package:flutter/material.dart';

class NorthWindLogo extends StatelessWidget {
  const NorthWindLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("./assets/img/wind-rose.png"),
        const Text(
          "NORTHWIND TRADERS",
          style: TextStyle(fontSize: 24, color: Colors.lightBlue),
        ),
      ],
    );
  }
}
