
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
<<<<<<< HEAD
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
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
=======
    return RefreshIndicator(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                height: 196.0,
                child: Text(widget.data[index] + ' tttttql', style: TextStyle(fontSize:18.0),),
              ),
>>>>>>> b2d51460c699c5de489f6188a7d4bccc1f3e977f
            ),
          );
        },
//      separatorBuilder: (BuildContext context, int index) => const Divider()
      ),
      onRefresh: () async {
        //TODO
      },
    );
  }

}