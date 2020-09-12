import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guzelankaram/models/ApiModel.dart';
import 'package:guzelankaram/models/category_model.dart';
import 'package:guzelankaram/models/search_model.dart';
import 'package:guzelankaram/utils/apiDetails.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart'as http;

class ApiService{


  FirebaseMessaging _fcm = FirebaseMessaging();


  Future<List<ApiModel>> getPost() async {
    //    // HTTP GET isteği ile veriyi Çek
    var response = await http.get(ApiDetails.postsUrl+"?"+ApiDetails.postFieldsFilters);
    List<ApiModel> posts = [];
    // HTTP Durum Kodunu İncele
    if (response.statusCode == 200) {
      // Veri Çekme Başarılı İse ApiModel.fromJsonMap Constructor'ı ile ApiModel nesnesi oluştur ve dönder.
      List mapList =  jsonDecode(response.body);

      for(int i=0; i<mapList.length; i++){
        posts.add(ApiModel.fromJson(mapList[i]));
      }

      return posts;
    } else {
      // veri Çekme Başarısız ise Bir Hata Fırlat
      print("getData (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getData (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }


  Future<String> getPostMedia(int mediaId) async{

    if(mediaId!=0){

    var response = await http.get(ApiDetails.mediaUrl+"/$mediaId"+"?"+ApiDetails.mediaFieldsFilters);


    if(response.statusCode == 200) {
      var mapList = jsonDecode(response.body);
      return mapList["source_url"];
    }else{
      print("getPostMedia (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      return "";

    }
    }else{
      return ApiDetails.logoUrl;
    }
  }



  Future<Map<String,dynamic>> getPostWithCategoryId(String id,String page) async{
    var response = await http.get(ApiDetails.postsUrl+"?categories=$id"+"&_fields=id"+"&page=$page");

    var totalPage = response.headers["x-wp-totalpages"];


    List<String> postIDs = [];

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
      print("getPostWithCategoryId (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getPostWithCategoryId (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }



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

  Future<Map<String,dynamic>> getPostIdWithPagination(int page) async{

    var response = await http.get(ApiDetails.postsUrl+"?"+"per_page=${ApiDetails.perPage}"+"&"+ApiDetails.postIdField+"&"+"page=$page");

    var totalPage = response.headers["x-wp-totalpages"];

    List<String> postIDs = [];

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

  Future<ApiModel> getPostId(String id) async{
    ApiModel post;
    var response = await http.get(ApiDetails.postsUrl+"/$id"+"?"+ApiDetails.postFieldsFilters);
    if(response.statusCode == 200){
      var map =  jsonDecode(response.body);
      post = ApiModel.fromJson(map);
      return post;
    }else{
      print("getPostId (response error code) [API_SERVICE] : "+ response.statusCode.toString());
      throw Exception("getPostId (response error code) [API_SERVICE] : " + response.statusCode.toString());
    }
  }


  Future<bool> registerNotificationService() async{
    //String deviceToken = await _fcm.getToken();



    return true;
  }

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


  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
}