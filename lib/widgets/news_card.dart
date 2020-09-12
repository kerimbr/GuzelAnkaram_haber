
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guzelankaram/models/ApiModel.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:guzelankaram/widgets/news_details.dart';
import 'package:provider/provider.dart';

class NewsCard extends StatefulWidget {

  String newsId;
  Key key;

  NewsCard({@required this.newsId,this.key}):super(key:key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    ViewModel _viewmodel = Provider.of<ViewModel>(context);
    String newsId = widget.newsId;

    return FutureBuilder<ApiModel>(
      future: getData(newsId),
      builder: (context, snapshot) {
        if(snapshot.hasData){
        ApiModel news = snapshot.data;
        return Stack(
          children: <Widget>[
            Card(
              color: Colors.grey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${news.title}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade200
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${news.content}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 12,
                                          color: Colors.grey.shade400
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              height: 130,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 130,
                            child: Image.network(
                              "${news.mediaUrl}",
                              fit: BoxFit.contain,
                            )
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "${news.date.day>=10?news.date.day:"0"+news.date.day.toString()} / "
                              "${news.date.month>10?news.date.month:"0"+news.date.month.toString()} / "
                              "${news.date.year}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Daha Fazla Detay İçin Dokunun",
                              style: TextStyle(
                                  fontSize: 10,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              AntDesign.rightcircle,
                              color: Colors.grey.shade200,
                              size: 10,
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5)
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Route r = MaterialPageRoute(
                        builder: (context)=>NewsDetailsPage(news: news)
                      );
                      Navigator.of(context).push(r);
                    },
                  ),
                ),
            ),
          ],
        );
        }else{
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child:  Card(
              color: Colors.grey.shade800,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 270,
                                          height: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width: 160,
                                          height: 15,
                                          color: Colors.grey.shade500,
                                        ),
                                      ],
                                    )
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 280,
                                          height: 10,
                                          color: Colors.grey.shade700,
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width: 110,
                                          height: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width: 210,
                                          height: 10,
                                          color: Colors.grey.shade700,
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                              height: 130,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              height: 130,
                              width: 30,
                            color: Colors.grey.shade700,
                            child: CupertinoActivityIndicator(
                              radius: 14,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
          );
        }
      }
    );
  }

  Future<ApiModel> getData(String newsId) async{
    ViewModel _viewmodel = Provider.of<ViewModel>(context,listen: false);

    ApiModel post;
    post = await _viewmodel.getPostId(newsId);
    post.mediaUrl = await _viewmodel.getPostMedia(post.mediaId);
    return post;
  }


}
