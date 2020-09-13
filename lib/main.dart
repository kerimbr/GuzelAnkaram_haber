import 'package:flutter/material.dart';
import 'package:guzelankaram/locator.dart';
import 'package:guzelankaram/pages/home_page.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:provider/provider.dart';

void main(){
  setup();
  runApp(GuzelAnkaram());
}


class GuzelAnkaram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Güzel Ankaram",
      theme: ThemeData(
        primaryColor: Colors.grey.shade800,// Color(0xff222222),
        primarySwatch: Colors.grey,
      ),
      home: ChangeNotifierProvider(
          create: (context)=>ViewModel(),
          child: HomePage(),
      ),
    );
  }
}
