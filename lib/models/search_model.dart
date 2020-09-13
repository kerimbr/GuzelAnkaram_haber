

import 'package:html/parser.dart';

class SearchModel{

  /*
  * SearchModel Sınıfı API'nin search path'i ile gelen veri için özel hazırlanmıştır.
  * Aranmış gönderilerin ID ve Name alanlarını tutar.
  * */

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