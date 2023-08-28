import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:northwind/components/activity_indicator.dart';
import 'package:northwind/components/search_bar.dart';
import '../../controllers/controller_class.dart';
import '../../models/shared/model_class.dart';
import '../../components/display_tile.dart';

/// View that displays all the models from the Database. Infers title name
/// and HTTP routes from [Model] T.
///
/// Requires [Model]'s .fromJson() constructor as a parameter.
class ViewFromModel<T extends Model> extends StatefulWidget {
  const ViewFromModel({
    Key? key,
    required this.fromJson,
    this.tileTitleWidget,
    this.tileSubTitleWidget,
    this.tileInnerWidget,
    this.searchFilter,
  }) : super(key: key);

  final T Function(Map<String, dynamic>) fromJson;
  final Widget? Function(T model)? tileTitleWidget;
  final Widget? Function(T model)? tileSubTitleWidget;
  final Widget? Function(
    T model,
    List<T>? models,
    List<T> displayedModels,
    void Function() updateModels,
  )? tileInnerWidget;
  final List<T> Function(List<T> models, String text)? searchFilter;

  @override
  State<ViewFromModel<T>> createState() => _ViewFromModelState();
}

class _ViewFromModelState<T extends Model> extends State<ViewFromModel<T>> {
  static const double _topPadding = 16;
  late final Future<List<T>> _fetchModels;
  List<T>? models;
  List<T> displayedModels = [];

  @override
  void initState() {
    var controller = Controller<T>(fromJson: widget.fromJson);
    _fetchModels = controller.getAll();
    super.initState();
  }

  Widget _viewTile(T model) {
    return NorthWindDisplayTile(
      titleWidget: (widget.tileTitleWidget != null)
          ? widget.tileTitleWidget!(model)
          : null,
      subtitleWidget: (widget.tileSubTitleWidget != null)
          ? widget.tileSubTitleWidget!(model)
          : null,
      innerWidget: (widget.tileInnerWidget != null)
          ? () {
              return widget.tileInnerWidget!(
                model,
                models,
                displayedModels,
                () {
                  setState(() {});
                },
              ); // Pass null as second parameter
            }()
          : null,
    );
  }

  Widget _listViewFromModels(List<T>? models) => ListView.builder(
        itemCount: models!.length,
        itemBuilder: (context, index) {
          return _viewTile(models[index]);
        },
      );

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: NorthWindSearchBar(
          onChanged: (text) {
            var newList = widget.searchFilter!(models!, text);
            setState(() {
              displayedModels = newList;
            });
          },
        ),
      );

  Widget _onSnapshotHasDataWidget(snapshot) {
    if (models == null) {
      models = snapshot.data ?? [];
      displayedModels = models!;
    }
    return Expanded(
      child: Column(
        children: [
          if (widget.searchFilter != null) _searchBar(),
          const Padding(padding: EdgeInsets.only(top: _topPadding)),
          Expanded(
            child: _listViewFromModels(displayedModels),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${T}s"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _fetchModels,
              builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
                if (snapshot.hasData) {
                  return _onSnapshotHasDataWidget(snapshot);
                } else if (snapshot.hasError) {
                  //! TODO: Proper Error Handling
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const NorthWindActivityIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
