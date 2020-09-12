import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<bool> removeToSavedList(String newsId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> tempList = await getSavedList();
    tempList.remove(newsId);
    return await pref.setStringList("pinned", tempList);
  }

  Future<bool> addToSaved(String newsId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> tempList = await getSavedList();
    tempList.add(newsId);
    return pref.setStringList("pinned", tempList);
  }

  Future<List<String>> getSavedList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> savedList = [];
    if (pref.containsKey("pinned")) {
      savedList = pref.getStringList("pinned");
      return savedList;
    } else {
      return [];
    }
  }
  
  Future<bool> registeredNotifications() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.containsKey("subscript")){
      return pref.getBool("subscript");
    }else{
      await setNotificationSubs();
      return false;
    }
  }

  Future<void> setNotificationSubs() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("subscript", true);
  }
  
}
