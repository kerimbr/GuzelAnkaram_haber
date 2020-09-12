import 'package:flutter/material.dart';
import 'package:guzelankaram/locator.dart';
import 'package:guzelankaram/models/ApiModel.dart';
import 'package:guzelankaram/models/category_model.dart';
import 'package:guzelankaram/models/search_model.dart';
import 'package:guzelankaram/uvvm_repository/repository.dart';




enum ViewState { IDLE, BUSY }

class ViewModel with ChangeNotifier{

  Repository _repository = locator<Repository>();
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;



  Future<List<ApiModel>> getPost() async {
    var result = await _repository.getPost();
    return result;
  }

  Future<String> getPostMedia(int mediaId) async {
    var result = await _repository.getPostMedia(mediaId);
    return result;
  }

  Future<Map<String,dynamic>> getPostWithCategoryId(String id,String page) async{
    var result = await _repository.getPostWithCategoryId(id,page);
    return result;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    var result = await _repository.getAllCategories();
    return result;
  }


  Future<Map<String,dynamic>> getPostIdWithPagination(int page) async{
    var result = await _repository.getPostIdWithPagination(page);
    return result;
  }

  Future<ApiModel> getPostId(String id) async{
    var result = await _repository.getPostId(id);
    return result;
  }

  Future<bool> addToSaved(String newsId) async {
    var result = await _repository.addToSaved(newsId);
    return result;
  }

  Future<List<String>> getSavedList() async {
    var result = await _repository.getSavedList();
    return result;
  }

  Future<bool> removeToSavedList(String newsId) async {
    var result = await _repository.removeToSavedList(newsId);
    return result;
  }

  Future<bool> registeredNotifications() async {
    var result = await _repository.registeredNotifications();
    return result;
  }


  Future<bool> registerNotificationService() async {
    var result = await _repository.registerNotificationService();
    return result;
  }

  Future<List<SearchModel>> getSearchResult(String searchText) async{
    var result = await _repository.getSearchResult(searchText);
    return result;
  }

}