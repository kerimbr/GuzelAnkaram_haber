import 'package:guzelankaram/locator.dart';
import 'package:guzelankaram/models/post_model.dart';
import 'package:guzelankaram/models/category_model.dart';
import 'package:guzelankaram/models/search_model.dart';
import 'package:guzelankaram/uvvm_services/api_service.dart';
import 'package:guzelankaram/uvvm_services/shared_preferences_service.dart';

class Repository{


  /*
  * Repository Sınıfı Tüm servisleri birleştiren köprü bir sınıftır
  * UVVM Mimarisi için gereklidir!
  *
  * */


  ApiService _apiService = locator<ApiService>();
  SharedPreferencesService _sps = locator<SharedPreferencesService>();



  Future<String> getPostMedia(int mediaId) async {
    var result = await _apiService.getPostMedia(mediaId);
    return result;
  }

  Future<Map<String,dynamic>> getPostWithCategoryId(String id,String page) async{
    var result = await _apiService.getPostWithCategoryId(id,page);
    return result;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    var result = await _apiService.getAllCategories();
    return result;
  }

  Future<Map<String,dynamic>> getPostIdWithPagination(int page) async{
    var result = await _apiService.getPostIdWithPagination(page);
    return result;
  }

  Future<Post> getPostId(String id) async{
    var result = await _apiService.getPostId(id);
    return result;
  }

  Future<bool> addToSaved(String newsId) async {
    var result = await _sps.addToSaved(newsId);
    return result;
  }

  Future<List<String>> getSavedList() async {
    var result = await _sps.getSavedList();
    return result;
  }

  Future<bool> removeToSavedList(String newsId) async {
    var result = await _sps.removeToSavedList(newsId);
    return result;
  }

  Future<bool> registeredNotifications() async {
    var result = await _sps.registeredNotifications();
    return result;
  }


  Future<List<SearchModel>> getSearchResult(String searchText) async{
    var result = await _apiService.getSearchResult(searchText);
    return result;
  }

}