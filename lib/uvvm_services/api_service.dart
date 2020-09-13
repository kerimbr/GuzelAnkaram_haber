import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guzelankaram/models/post_model.dart';
import 'package:guzelankaram/models/category_model.dart';
import 'package:guzelankaram/models/search_model.dart';
import 'package:guzelankaram/utils/apiDetails.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart'as http;

class ApiService{

  /*
  * ApiService sınıfı bağlantı, veri getirme ve veri yazma işlemlerinin yapıldığı (BackEnd) kısmıdır.
  * UVVM mimarisi ile hazırlanmıştır.
  * [FCM işlemleride bu sınıf içerisinde yapılmıştır!]
  * */


  // FCM'i Kur
  FirebaseMessaging _fcm = FirebaseMessaging();



  // Tek bir gönderinin görselini sunucudan almak için kullanılan metod
  // Görsel URL'i dönderir.
  Future<String> getPostMedia(int mediaId) async{

    if(mediaId!=0){ // Eğer görsel medyası varsa; Medyayı al

    // API'nin medya URL'ine GET isteği at
    var response = await http.get(ApiDetails.mediaUrl+"/$mediaId"+"?"+ApiDetails.mediaFieldsFilters);


    if(response.statusCode == 200) { // İstek cevabı başarılı ise;
      // Gelen isteğin body kısmını (JSON) decode et ve bir değişkene aktar.
      var mapList = jsonDecode(response.body);
      // Görsel URL'sini dönder
      return mapList["source_url"];
    }else{// İstek cevabı başarısız ise;
      print("getPostMedia (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      return "";
    }
    }else{ // Eğer görsel medyası yoksa; Site logosunu al
      return ApiDetails.logoUrl;
    }
  }


  // ID'si girilmiş kategorinin içerisindeki gönderileri al (PAGİNATİON UYGULANMIŞTIR)
  Future<Map<String,dynamic>> getPostWithCategoryId(String id,String page) async{
    // API' GET isteği gönder
    var response = await http.get(ApiDetails.postsUrl+"?categories=$id"+"&_fields=id"+"&page=$page");

    // Gelen İSteğin HEADERS kısmından toplam sayfa sayısını al ve bir değişkene aktar
    var totalPage = response.headers["x-wp-totalpages"];


    List<String> postIDs = [];

    // PostID' lerini ve toplam sayfa sayısını tutan bir MAP'yapısı oluştur.
    Map<String,dynamic> postsAndPageInfo;


    if (response.statusCode == 200) {
      List mapList =  jsonDecode(response.body);

      for(int i=0; i<mapList.length; i++){
        postIDs.add(mapList[i]["id"].toString());
      }

      postsAndPageInfo = {
        "postIDs" : postIDs,
        "totalPages" : totalPage
      };

      // Oluşturulan MAP'i dönder.
      return postsAndPageInfo;
    } else {
      // veri Çekme Başarısız ise Bir Hata Fırlat
      print("getPostWithCategoryId (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getPostWithCategoryId (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }



  // Tüm Kategorileri Al ve bir CategoryModel Listesi döndür.
  Future<List<CategoryModel>> getAllCategories() async {
    var response = await http.get(ApiDetails.categoriesUrl+"?"+ApiDetails.categoriesFieldsFilters);
    List<CategoryModel> categories = [];

    if (response.statusCode == 200) {
      List mapList =  jsonDecode(response.body);

      for(int i=0; i<mapList.length; i++){
        categories.add(CategoryModel.fromJson(mapList[i]));
      }

      return categories;
    } else {
      print("getAllCategories (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getAllCategories (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }

  // Gönderi ID'lerini al (PAGİNATİON KULLANILMIŞTIR)
  Future<Map<String,dynamic>> getPostIdWithPagination(int page) async{

    var response = await http.get(ApiDetails.postsUrl+"?"+"per_page=${ApiDetails.perPage}"+"&"+ApiDetails.postIdField+"&"+"page=$page");

    // Toplam gönderiler için toplam sayfa sayısını al
    var totalPage = response.headers["x-wp-totalpages"];

    List<String> postIDs = [];

    // Toplam sayfa sayısını ve Gönderi ID lerini içeren MAP yapısı
    Map<String,dynamic> postsAndPageInfo;

    if (response.statusCode == 200) {
      List mapList =  jsonDecode(response.body);

      for(int i=0; i<mapList.length; i++){
        postIDs.add(mapList[i]["id"].toString());
      }

      postsAndPageInfo = {
        "postIDs" : postIDs,
        "totalPages" : totalPage
      };

      return postsAndPageInfo;
    } else {
      // veri Çekme Başarısız ise Bir Hata Fırlat
      print("getPostIdWithPagination (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getPostIdWithPagination (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }

  // Gönderi ID'sine göre Gönderi detaylarını al
  Future<Post> getPostId(String id) async{
    Post post;
    var response = await http.get(ApiDetails.postsUrl+"/$id"+"?"+ApiDetails.postFieldsFilters);
    if(response.statusCode == 200){
      var map =  jsonDecode(response.body);
      post = Post.fromJson(map);
      return post;
    }else{
      print("getPostId (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getPostId (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }


  // Arama Metnine göre API'den arama sonuçlarına ait SEARCHMODEL sınıfının listesini dönderir.
  Future<List<SearchModel>> getSearchResult(String searchText) async{
    List<SearchModel> posts = [];
    var response = await http.get(ApiDetails.searchUrl+"?"+ApiDetails.searchFields+"&search="+searchText);

    if (response.statusCode == 200){
      List mapList =  jsonDecode(response.body);

      for(int i=0; i<mapList.length; i++){
        posts.add(SearchModel.fromJson(mapList[i]));
      }

      return posts;
    }else{
      print("getSearchResult (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getSearchResult (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }

  }


  // HTML olarak gelen String verilerini pürüzsüzleştirmek için kullanılan metod
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
}