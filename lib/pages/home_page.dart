import 'package:cat_app/widgets/page_with_tabs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWithTabs(
      content: Container(
        child: Text('home page'),
      ),
    );
  }
}
