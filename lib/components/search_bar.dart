import 'package:flutter/material.dart';

class NorthWindSearchBar extends StatelessWidget {
  const NorthWindSearchBar({super.key, this.onChanged, this.onTap});
  final Function(String)? onChanged;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(builder: (BuildContext context, SearchController _) {
      return SearchBar(
        padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
        onTap: onTap,
        onChanged: onChanged,
        leading: const Icon(Icons.search),
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return [];
    });
  }
}
