import 'package:flutter/material.dart';

class NorthWindHeader extends StatelessWidget {
  const NorthWindHeader({super.key, this.child});
  final Widget? child;
  final double innerPadding = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        border: const Border(
          top: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: Padding(
        //? Linter is bugged and wants to make this a const, which will break during runtime.
        // ignore: prefer_const_constructors
        padding: EdgeInsets.all(innerPadding),
        child: (child != null) ? child : Container(),
      ),
    );
  }
}
