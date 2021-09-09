import 'package:flutter/material.dart';
import 'package:sample/seach_persist.dart';
import 'package:sample/search_normal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Simple Search Sample'),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => SearchDemoNormal(),
                  ),
                );
              },
              child: Text('Demo normal'),
            ),
            SizedBox.fromSize(
              size: Size.fromRadius(8),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => SearchDemoPersist(),
                  ),
                );
              },
              child: Text('Demo persist'),
            ),
          ],
        ),
      ),
    );
  }
}
