import 'package:flutter/material.dart';

@immutable
class NorthWindDisplayTile extends StatefulWidget {
  const NorthWindDisplayTile(
      {super.key, this.titleWidget, this.subtitleWidget, this.innerWidget});
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final Widget? innerWidget;

  @override
  State<NorthWindDisplayTile> createState() => _NorthWindDisplayTileState();
}

class _NorthWindDisplayTileState extends State<NorthWindDisplayTile> {
  bool _showInfo = false;

  Widget _headerTile() => ListTile(
        tileColor: (_showInfo)
            ? Theme.of(context).colorScheme.inversePrimary
            : Colors.white,
        title: widget.titleWidget,
        subtitle: widget.subtitleWidget,
        trailing: (widget.innerWidget != null)
            ? IconButton(
                onPressed: () => setState(() {
                  _showInfo = !_showInfo;
                }),
                icon: Transform.flip(
                  flipY: (_showInfo),
                  child: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: (_showInfo) ? Colors.white : Colors.grey,
                  ),
                ),
              )
            : Container(),
      );

  Widget _infoTile() => ListTile(
        tileColor: Colors.grey.shade200,
        title: widget.innerWidget,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerTile(),
        if (_showInfo) _infoTile(),
      ],
    );
  }
}
