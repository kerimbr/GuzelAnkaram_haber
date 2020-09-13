

import 'package:html/parser.dart';

class CategoryModel{

  /*
  * CategoryModel sınıfı Kategorilerin ID ve Name alanlarını tutması için oluşturuldu
  *
  * */

  String id;
  String name;

  CategoryModel({
    this.id,
    this.name
  });

  CategoryModel.fromJson(Map<String,dynamic> map):
      id = map["id"].toString(),
      name = parseHtmlString(map["name"]);


  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

}