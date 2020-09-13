import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guzelankaram/pages/search_page.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:guzelankaram/widgets/news_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {

  // ANA SAYFA

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int totalPage;
  int currentPage;

  bool loadingPage = false;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    ViewModel _viewmodel = Provider.of<ViewModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff222222),
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: "Güzel ",
            style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w400),
            children: [
              TextSpan(
                text: "Ankaram",
                style: GoogleFonts.notoSans(fontWeight: FontWeight.bold, color: Colors.redAccent),
              )
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Feather.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Route r = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context)=>SearchPage()
              );
              Navigator.of(context).push(r);
            },
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<String>>(
            future: _homePageFutures(currentPage),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(loadingPage==false){
                return ListView.separated(
                  itemCount: snapshot.data.length + 2,
                  addAutomaticKeepAlives: true,
                  separatorBuilder: (context, i) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index == 0 || index == (snapshot.data.length + 1)) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            // Önceki Sayfaya Git
                            InkWell(
                              onTap: () async {
                                if (currentPage != 1) {
                                  setState(() {
                                    currentPage -= 1;
                                  });
                                } else {
                                  await Fluttertoast.showToast(
                                      msg: "İlk Sayfadasınız",
                                      backgroundColor: Colors.pinkAccent,
                                      gravity: ToastGravity.BOTTOM);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FlutterIcons.arrow_left_circle_fea,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Önceki Sayfaya",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            CircleAvatar(
                              child: Text("$currentPage"),
                            ),

                            // Sonraki Sayfaya Git
                            InkWell(
                              onTap: () async {
                                if (currentPage != totalPage) {
                                  setState(() {
                                    currentPage += 1;
                                  });
                                } else {
                                  await Fluttertoast.showToast(
                                      msg: "Son Sayfadasınız",
                                      backgroundColor: Colors.pinkAccent,
                                      gravity: ToastGravity.BOTTOM);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Sonraki Sayfaya",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      FlutterIcons.arrow_right_circle_fea,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return NewsCard(
                        newsId: snapshot.data[index - 1],
                      );
                    }
                  },
                );
                }else{
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                          strokeWidth: 2,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Haberler Yükleniyor...",
                          style: TextStyle(color: Colors.grey.shade200),
                        )
                      ],
                    ),
                  );
                }
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Haberler Yükleniyor...",
                        style: TextStyle(color: Colors.grey.shade200),
                      )
                    ],
                  ),
                );
              }
            })
      ),
    );
  }

  Widget _buildDrawer() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.grey.shade900,
      ),
      child: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Güzel ",
                  style: GoogleFonts.notoSans(fontSize: 30, fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(
                      text: "Ankaram",
                      style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.bold, color: Colors.redAccent),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  EvilIcons.clock,
                  color: Colors.deepOrangeAccent,
                ),
                SizedBox(width: 5),
                Text(
                  "${DateTime.now().day >= 10 ? DateTime.now().day : "0" + DateTime.now().day.toString()} / "
                  "${DateTime.now().month > 10 ? DateTime.now().month : "0" + DateTime.now().month.toString()} / "
                  "${DateTime.now().year}",
                  style: TextStyle(color: Colors.orangeAccent.shade200),
                ),
              ],
            ),
            Divider(
              height: 40,
              color: Colors.grey.shade800,
            ),

            // WEB
            ListTile(
              leading: Icon(
                MaterialCommunityIcons.web,
                color: Colors.indigo,
              ),
              title: Text(
                "İnternet Sitesine Git",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser("https://guzelankaram.com/");
              },
            ),

            // Bize Ulaşın
            ListTile(
              leading: Icon(
                MaterialCommunityIcons.web,
                color: Colors.pinkAccent,
              ),
              title: Text(
                "Bize Ulaşın",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser("https://guzelankaram.com/bize-ulasin/");
              },
            ),

            Divider(
              height: 40,
              color: Colors.grey.shade800,
            ),

            // Facebook
            ListTile(
              leading: Icon(
                Entypo.facebook,
                color: Colors.blueAccent,
              ),
              title: Text(
                "Facebook",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser("https://www.facebook.com/Guzel-Ankaram-Gazetesi-112359077259178");
              },
            ),
            // Youtube
            ListTile(
              leading: Icon(
                AntDesign.youtube,
                color: Colors.red,
              ),
              title: Text(
                "Youtube",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser(
                    "https://www.youtube.com/channel/UCvD6Vp3Y4l-e8bLqgkgZs9w/?guided_help_flow=5");
              },
            ),

            // Twitter
            ListTile(
              leading: Icon(
                AntDesign.twitter,
                color: Colors.lightBlueAccent,
              ),
              title: Text(
                "Twitter",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser("https://twitter.com/guzelankaram");
              },
            ),

            // Whatsapp
            ListTile(
              leading: Icon(
                FlutterIcons.whatsapp_faw,
                color: Colors.green,
              ),
              title: Text(
                "WhatsApp",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser("https://guzelankaram.com/bize-ulasin/#");
              },
            ),

            // Instagram
            ListTile(
              leading: Icon(
                Feather.instagram,
                color: Colors.grey.shade300,
              ),
              title: Text(
                "Instagram",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(color: Colors.grey.shade200, fontSize: 16),
              ),
              onTap: () {
                _goBrowser("https://www.instagram.com/gazeteguzelankaram/");
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  void _goBrowser(String url) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text("Tarayıcıya Gidilsin mi ?"),
            //content: new Text("This is my content"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Git"),
                onPressed: () {
                  Navigator.pop(context);
                  _launchURL(url);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<String>> _homePageFutures(int page) async {
    ViewModel _viewmodel = Provider.of<ViewModel>(context, listen: false);

    loadingPage = true;


    Map<String, dynamic> postsAndPageInfo;

    // Haberleri Al
    List<String> ids;
    postsAndPageInfo = await _viewmodel.getPostIdWithPagination(page);
    ids = postsAndPageInfo["postIDs"];
    totalPage = int.parse(postsAndPageInfo["totalPages"]);


    loadingPage = false;

    return ids;
  }
}
