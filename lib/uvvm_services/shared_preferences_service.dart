import 'package:shared_preferences/shared_preferences.dart';




class SharedPreferencesService {

  /*
       SharedPreferencesService Sınıfı Localde veri depolama işlemini sağlar.
       XML olarak verileri saklar.
   */


  // Kaydedilen Haberler Listesine Haber ID'si siler
  Future<bool> removeToSavedList(String newsId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> tempList = await getSavedList();
    tempList.remove(newsId);
    return await pref.setStringList("pinned", tempList);
  }

  // Kaydedilen Haberler Listesine Haber ID si ekler
  Future<bool> addToSaved(String newsId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> tempList = await getSavedList();
    tempList.add(newsId);
    return pref.setStringList("pinned", tempList);
  }

  // Kaydedilen Haberler listesini Alır
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


  // Uygulamayı İlk Çalıştırmada bildirim servisine kayıt etmesi için false gönderir.
  // Eğer kullanıcı bildirim servisine kayıtlı ise true değer gönderir
  Future<bool> registeredNotifications() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.containsKey("subscript")){
      return pref.getBool("subscript");
    }else{
      await pref.setBool("subscript", true);
      return false;
    }
  }


}
