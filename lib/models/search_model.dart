

import 'package:html/parser.dart';

class SearchModel{

  String id;
  String title;

  SearchModel({this.id, this.title});

  SearchModel.fromJson(Map<String,dynamic> map):
      id = map["id"].toString(),
      title = parseHtmlString(map["title"]);


  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

}