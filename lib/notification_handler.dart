
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// TOP LEVEL Türünde arkaplanda bildirim yakalama metodu
Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arkplanda gelen data : "+message["data"].toString());

    NotificationHandler().showNotification(message);

  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  return Future<void>.value();
  // Or do other work.
}





class NotificationHandler{


  // Tek Bir nesne Oluşturmak ve Herzaman bu Sınıftan Bu nesne ile çalışmak için gerekli singleton yapısı
  static final NotificationHandler _singleton =   NotificationHandler._internal();
  factory NotificationHandler(){
    return _singleton;
  }
  NotificationHandler._internal();

  // Fİrebase Cloud Message Sınıfından nesne oluştur
  FirebaseMessaging _fcm = FirebaseMessaging();


  initializeFCMNotification() async{


    // Flutter Local Notification Plugin Kurulumu
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings =    InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);


    // Bildirim Kanalına Kayıt ol
    _fcm.subscribeToTopic("/topics/all");

    // fcm ayarları
    _fcm.configure(
      onMessage: (Map<String,dynamic> data) async{
        print("on message tetiklendi:");
        print(data);
        showNotification(data);
      },
      onLaunch: (Map<String,dynamic> data) async{
        print("on onLaunch tetiklendi:");
        print(data);
      },
      onResume: (Map<String,dynamic> data) async{
        print("on onResume tetiklendi:");
        print(data);
      },

      // Arkaplanda Bildirim yakalayan TOP LEVEL Metodu Buraya Geçtik
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,

    );


  }


  // Flutter Local Notification Plugini ile Bildirimi Göster
  void showNotification(Map<String, dynamic> message) async{

    var bigPicturePath = await _downloadAndSaveFile(
        message["data"]["image-url"], "${message["data"]["id"]}.jpg");

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        attachments: [IOSNotificationAttachment(bigPicturePath)]);

    var bigPictureAndroidStyle =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'news_id', 'Haberler', 'Tüm Haber Bildirimleri',
        importance: Importance.High,
        priority: Priority.High,
        styleInformation: bigPictureAndroidStyle);

    var notificationDetails = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0,
        message["data"]["title"],
        "Haberi okumak için dokunun",
        notificationDetails,
        payload: message["data"]["id"]
    );

  }



  // Android İçin Bildirime Tıklanınca
  Future selectNotification(String payload) {
    if (payload != null) {
      print('Bildirime Tıklanınca Gelen Veri(ANDROID)' + payload);
    }
  }

  // IOS İçin Bildirime Tıklanınca
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
    if (payload != null) {
      print('Bildirime Tıklanınca Gelen Veri(IOS)' + payload);
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }



}