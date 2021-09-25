import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipecount/cmr/cam.dart';
import 'package:pipecount/ervice/pi.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => EnPoint()),
        ChangeNotifierProvider(create: (context) => CmKK()),
      ], child: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cm = Provider.of<CmKK>(context);
    final network = Provider.of<EnPoint>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: double.infinity),
          cm.file == null
              ? Align(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    color: Colors.blueAccent,
                    child: Text('Select an Image'),
                    onPressed: () => cm.optionsDialogBox(context),
                  ),
                )
              : Container(
                  width: 400,
                  child: network.daata.isEmpty
                      ? Image.file(cm.file, fit: BoxFit.fitWidth)
                      : Image.memory(
                          base64Decode(network.daata.first.image),
                          fit: BoxFit.fitWidth,
                        ),
                ),
          cm.file != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CupertinoButton(
                        color: Colors.red,
                        child: Text('Remove'),
                        onPressed: () {
                          cm.removeimage();
                          network.removeImage();
                        },
                      ),
                      SizedBox(width: 20),
                      CupertinoButton(
                        color: Colors.blueAccent,
                        child: Text('Upload'),
                        onPressed: () async {
                          try {
                            await network.getCl(cm.file);
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          cm.file != null
              ? CupertinoButton(
                  color: Colors.greenAccent,
                  child: network.temp
                      ? CircularProgressIndicator()
                      : Text('Predict'),
                  onPressed: () async {
                    try {
                      await network.getData();
                    } catch (e) {
                      print(e);
                    }
                  },
                )
              : SizedBox(),
          network.daata.isEmpty
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        network.daata.first.itemNumber.toString(),
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
