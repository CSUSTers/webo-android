
import 'package:flutter/material.dart';

class WebOListView extends StatefulWidget {
  WebOListView({Key key, this.data}) : super(key: key);

  final List<String> data;

  @override
  _WebOListViewState createState() => _WebOListViewState();

}


class _WebOListViewState extends State<WebOListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            splashColor: Colors.grey.withAlpha(30),
            onTap: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(widget.data[index] + ' txdy'),
                duration: Duration(milliseconds: 2000),
              ));
            },
            child: Container(
              height: 196,
              child: Text(widget.data[index] + ' tttttql', style: TextStyle(fontSize:18.0),),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider()
    );
  }

}