

import 'package:html/parser.dart';

class Post{

  /*
  * Post Sınıfı API'den gelen Gönderiler için özel oluşturulmuş bir sınıftır.
  * Haber verilerini tutar.
  * */

  String id;
  String title;
  String content;
  DateTime date;
  String link;
  int mediaId;
  List<dynamic> categoriesId;

  String mediaUrl;

  Post({
    this.title,
    this.id,
    this.content,
    this.date,
    this.link,
    this.mediaId,
    this.categoriesId,
    this.mediaUrl
  });

  Post.fromJson(Map<String,dynamic> map):
      title = parseHtmlString(map["title"]["rendered"]),
      id = map["id"].toString(),
      content = parseHtmlString(map["content"]["rendered"]),
      date = DateTime.parse(map["date"]),
      link = map["link"],
      mediaId = map["featured_media"],
      mediaUrl = "",
      categoriesId = map["categories"];


  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }


}