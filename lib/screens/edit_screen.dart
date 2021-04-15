import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rich_code_editor/exports.dart';
import "package:http/http.dart" as http;

import '../constants.dart';
import '../syntax_highlighter.dart';

class EditArguments {
  final String ocrResult;
  EditArguments(this.ocrResult);
}

class EditScreen extends StatefulWidget {
  final String ocrResult;
  EditScreen({this.ocrResult});
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCodeEditor(widget.ocrResult);
  }
}

class DemoCodeEditor extends StatefulWidget {
  final String ocrResult;
  DemoCodeEditor(this.ocrResult);
  @override
  _DemoCodeEditorState createState() => _DemoCodeEditorState(ocrResult);
}

class _DemoCodeEditorState extends State<DemoCodeEditor> {
  RichCodeEditingController _rec;
  SyntaxHighlighterBase _syntaxHighlighterBase;
  bool isExecutingCode = false;

  final String ocrResult;
  String _codeToExec;
  _DemoCodeEditorState(this.ocrResult);

  @override
  void initState() {
    super.initState();
    _syntaxHighlighterBase = SyntaxHighlighter();
    _rec = RichCodeEditingController(_syntaxHighlighterBase, text: ocrResult);
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Your snippet has been succesfully saved.'),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.backgroundColor,
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: "Snippet Name",
                          hintText: "DragonHeSnippet3",
                          hintStyle: TextStyle(
                            color: Colors.white30,
                          ),
                          helperStyle: TextStyle(
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.all(24.0),
                        padding: EdgeInsets.all(24.0),
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.grey)),
                        child: RichCodeField(
                          autofocus: true,
                          controller: _rec,
                          textCapitalization: TextCapitalization.none,
                          syntaxHighlighter: _syntaxHighlighterBase,
                          decoration: null,
                          maxLines: null,
                          onChanged: (String s) {},
                          onBackSpacePress: (TextEditingValue oldValue) {},
                          onEnterPress: (TextEditingValue oldValue) {
                            var result =
                                _syntaxHighlighterBase.onEnterPress(oldValue);
                            if (result != null) {
                              _rec.value = result;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: [
                    
                    Column(
                      children: [
                        Text(
                          "Code Output:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        Visibility(
                          visible: isExecutingCode,
                          child: Container(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Container(
                          child: Text(
                            _execOutput,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: GFButton(
                            onPressed: () {
                              executeCode();
                            },
                            text: "Execute",
                            icon: Icon(Icons.code),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            color: GFColors.PRIMARY,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: GFButton(
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                            text: "Save",
                            icon: Icon(Icons.save),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            color: GFColors.SUCCESS,
                          ),
                        ),
                      ],
                    ),
          ],
        ),
      ),
    );
  }

  String _execOutput = "";

  Future executeCode() async {
    setState(() {
      isExecutingCode = true;
      _execOutput = "";
    });
    Dio dio = new Dio();
    var response = await dio.post(
      "https://camcoderapi.herokuapp.com/api/run",
      data: {
        "code": _rec.text,
      },
    );
    if (this.mounted) {
      setState(() {
        print(response.data);
        isExecutingCode = false;
        if (response.data["output"] != "") {
          _execOutput = response.data["output"].toString();
        } else {
          _execOutput = response.data["errors"].toString();
        }
      });
    }
  }
}