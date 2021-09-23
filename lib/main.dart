import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipecount/cmr/cam.dart';
import 'package:pipecount/ervice/pi.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EnPoint()),
        ChangeNotifierProvider(create: (context) => CmKK()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
        children: [
          Container(width: double.infinity),
          cm.file == null
              ? Center(
                  child: CupertinoButton(
                    color: Colors.blueAccent,
                    child: Text('Hello'),
                    onPressed: () => cm.optionsDialogBox(context),
                  ),
                )
              : Container(
                  height: 500,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 500,
                        child: Image.file(cm.file),
                      ),
                      Container(
                        width: 500,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
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
                        onPressed: () => cm.removeimage(),
                      ),
                      SizedBox(width: 20),
                      CupertinoButton(
                        color: Colors.blueAccent,
                        child: Text('Show'),
                        onPressed: () async {
                          try {
                            await network.getCl(cm.file);
                            cm.removeimage();
                            await network.getData();
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
