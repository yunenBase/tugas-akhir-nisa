import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dua Button dan Widget',
      home: SimplePage(),
    );
  }
}

class SimplePage extends StatefulWidget {
  @override
  _SimplePageState createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage> {
  Widget displayedWidget = SizedBox(); // Awalnya kosong

  void _showWidget1() {
    setState(() {
      displayedWidget = Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Ini adalah kontainer dari Button 1',
          style: TextStyle(fontSize: 16),
        ),
      );
    });
  }

  void _showWidget2() {
    setState(() {
      displayedWidget = Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 40),
            SizedBox(height: 10),
            Text(
              'Ini adalah kontainer dari Button 2',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contoh Dua Button & Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showWidget1,
                  child: Text('Button 1'),
                ),
                ElevatedButton(
                  onPressed: _showWidget2,
                  child: Text('Button 2'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: displayedWidget,
            ),
          ],
        ),
      ),
    );
  }
}
