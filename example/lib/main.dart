import 'package:example/test.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimized Search Field Example',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String currentItem;
  @override
  void initState() {
    currentItem = 'none';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              spacing: 40,
              children: [
                Text(
                  'You Choose: $currentItem',
                  style: TextStyle(fontSize: 24),
                ),
                OptimizedSearchField(
                  onChanged:
                      (text) => setState(() {
                        currentItem = text;
                      }),
                  labelText: currentItem,
                  dropDownList: List.generate(1000, (index) => 'item $index'),
                  itemTextStyle: TextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
