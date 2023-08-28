import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NorthWindActivityIndicator extends StatelessWidget {
  const NorthWindActivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: Theme.of(context).colorScheme.primary,
      radius: 32,
    );
  }
}
