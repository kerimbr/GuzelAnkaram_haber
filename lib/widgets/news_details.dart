import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guzelankaram/models/ApiModel.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatefulWidget {
  ApiModel news;

  NewsDetailsPage({this.news});

  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  bool pinned = false;
  GlobalKey<ScaffoldState> _newsDetailScaffoldKey = GlobalKey();
  bool pinnedLoading = false;

  @override
  Widget build(BuildContext context) {

    ViewModel _viewmodel = Provider.of<ViewModel>(context);

    ApiModel news = widget.news;
    return SafeArea(
      child: Scaffold(
        key: _newsDetailScaffoldKey,
        backgroundColor: Color(0xff222222),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Entypo.chevron_with_circle_left, size: 30),
                ),
                iconTheme: IconThemeData(color: Colors.red.shade800),
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(bottom: 14, left: 50),
                    title: Text(
                      "${news.title}",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-1, -1),
                              color: Colors.black),
                          Shadow(
                              // bottomRight
                              offset: Offset(-1, -1),
                              color: Colors.black),
                          Shadow(
                              // topRight
                              offset: Offset(-1, -1),
                              color: Colors.black),
                          Shadow(
                              // topLeft
                              offset: Offset(-1, -1),
                              color: Colors.black),
                        ],
                      ),
                    ),
                    background: Image.network(
                      "${news.mediaUrl}",
                      fit: BoxFit.cover,
                    )),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    Icon(
                      CupertinoIcons.time_solid,
                      color: Colors.deepOrangeAccent,
                      size: 22,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${news.date.day > 10 ? news.date.day : "0" + news.date.day.toString()} / "
                      "${news.date.month > 10 ? news.date.month : "0" + news.date.month.toString()} / "
                      "${news.date.year}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Entypo.link,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: "${news.link}"));
                        _newsDetailScaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            "Bağlantı Kopyalandı",
                            textAlign: TextAlign.center,
                          ),
                          behavior: SnackBarBehavior.fixed,
                          backgroundColor: Colors.pinkAccent,
                        ));
                      },
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        MaterialCommunityIcons.web,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        _goBrowser("${news.link}");
                      },
                    ),
                    SizedBox(width: 10),
                    FutureBuilder<bool>(
                      future: _checkPinned(news.id),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                        return IconButton(
                          icon: !pinned
                              ? Icon(
                                  AntDesign.pushpino,
                                  color: Colors.grey.shade400,
                                )
                              : Icon(
                                  AntDesign.pushpin,
                                  color: Colors.redAccent,
                                ),
                          onPressed: () async {
                            if (!pinnedLoading) {
                              setState(() {
                                pinnedLoading = true;
                              });


                              if (pinned) {

                                await _viewmodel.removeToSavedList(news.id);

                                setState(() {
                                  pinned = false;
                                });


                              } else {

                                await _viewmodel.addToSaved(news.id);

                                setState(() {
                                  pinned = true;
                                });

                              }


                              setState(() {
                                pinnedLoading = false;
                              });
                            }
                          },
                        );
                        }else{
                          return Container(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${news.title}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 24, color: Colors.grey.shade200, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "${news.content}",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.ubuntu(
                        fontSize: 14, color: Colors.grey.shade300, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 50),
                RaisedButton(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    _goBrowser("${news.link}");
                  },
                  color: Colors.orangeAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Tarayıcıda Görüntüle",
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  Future<bool> _checkPinned(String id) async{
    ViewModel _viewmodel = Provider.of<ViewModel>(context,listen: false);
    List<String> savedList;
    savedList = await _viewmodel.getSavedList();
    pinned = savedList.contains(id);
    return pinned;
  }
}
