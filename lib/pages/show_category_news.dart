import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:guzelankaram/widgets/news_card.dart';
import 'package:provider/provider.dart';

class ShowCategoryNews extends StatefulWidget {
  String categoryId;
  String categoryName;

  ShowCategoryNews({@required this.categoryId, @required this.categoryName});

  @override
  _ShowCategoryNewsState createState() => _ShowCategoryNewsState();
}

class _ShowCategoryNewsState extends State<ShowCategoryNews> {
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

    String id = widget.categoryId;
    String name = widget.categoryName;

    return Scaffold(
      backgroundColor: Color(0xff222222),
      appBar: AppBar(
        title: Text("$name"),
      ),
      body: FutureBuilder<List<String>>(
          future: _showCategoryPostPageFutures(id,currentPage.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (loadingPage == false) {
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
          }),
    );
  }

  Future<List<String>> _showCategoryPostPageFutures(String categoryId,String page) async {
    ViewModel _viewmodel = Provider.of<ViewModel>(context, listen: false);

    loadingPage = true;


    Map<String, dynamic> postsAndPageInfo;

    // Haberleri Al
    List<String> ids;
    postsAndPageInfo = await _viewmodel.getPostWithCategoryId(categoryId,page);
    ids = postsAndPageInfo["postIDs"];
    totalPage = int.parse(postsAndPageInfo["totalPages"]);

    loadingPage = false;

    return ids;
  }
}
