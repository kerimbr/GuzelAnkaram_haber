class ApiDetails{

  static String logoUrl = "https://guzelankaram.com/wp-content/uploads/2020/09/WhatsApp-Image-2020-09-07-at-8.24.09-PM.jpeg";


  static String postsUrl = "https://guzelankaram.com/wp-json/wp/v2/posts";
  static String baseUrl = "https://guzelankaram.com";
  static String mediaUrl = "https://guzelankaram.com/wp-json/wp/v2/media";
  static String categoriesUrl = "https://guzelankaram.com/wp-json/wp/v2/categories";
  static String searchUrl = "https://guzelankaram.com/wp-json/wp/v2/search";



  static String postFieldsFilters = "_fields=id,title,content,date,link,featured_media,categories";
  static String mediaFieldsFilters = "_fields=source_url";
  static String categoriesFieldsFilters = "_fields=id,name";
  static String postIdField = "_fields=id";
  static String searchFields = "_fields=id,title";


  static int perPage = 10;




  static String WPfcmRegister = "?api_secret_key=gn82PDeKrYFpp\$\$D^*7%pKFv&user_email=guzelankaramfcm@gmail.com&subscribed=Haberler&device_token=";

}