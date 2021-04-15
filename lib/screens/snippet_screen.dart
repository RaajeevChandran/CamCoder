import 'package:camcoder/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:camcoder/constants.dart';

import '../widgets/photo_code_app_bar.dart';

class SnippetScreen extends StatelessWidget {
  final String name, code;
  final ImageProvider image;

  SnippetScreen({
    @required this.name,
    @required this.code,
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PhotoCodeAppBar(showBackButton: true),
      backgroundColor: Constants.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 7),
          Text(
            name,
            style: TextStyle(
              color: Constants.textColor,
              fontSize: 25,
            ),
          ),
          Spacer(flex: 4),
          Container(
            height: 200,
            child: Image(image: image),
          ),
          HighlightView(
            code,
            language: 'javascript',
            theme: githubTheme,
            padding: EdgeInsets.all(10),
            textStyle: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 16,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 3),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>EditScreen()));
                },
                child: Row(children:[Icon(Icons.edit),Text('Edit')]),
                style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent))
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                },
                child: Row(children:[Icon(Icons.code_sharp),Text('Execute')]),
                style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade400))
              ),
              Spacer(flex: 3),
            ],
          ),
          Spacer(flex: 7),
        ],
      ),
    );
  }
}
