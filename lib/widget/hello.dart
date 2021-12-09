import 'package:flutter/material.dart';
import 'package:signin/UIConstant/theme.dart';

class MyPage extends StatelessWidget {
  List<Widget> _getChildren(int count, String name) => List<Widget>.generate(
        count,
        (i) => ListTile(
          title: Text('$name$i'),
          trailing: Wrap(
            spacing: 12, // space between two icons
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: UIConstant.blue,
                ),
                onPressed: () {},
              ), // icon-1
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: UIConstant.blue,
                ),
                onPressed: () async {},
              ), // icon-2
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('List-A'),
            children: _getChildren(4, 'A-'),
          ),
          ExpansionTile(
            title: Text('List-B'),
            children: _getChildren(3, 'B-'),
          ),
        ],
      ),
    );
  }
}
