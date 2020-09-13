import 'package:flutter/material.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:guzelankaram/widgets/news_card.dart';
import 'package:provider/provider.dart';



class SavesPage extends StatefulWidget {

 // Kaydedilen Haberler Sayfası

  @override
  _SavesPageState createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  @override
  Widget build(BuildContext context) {
    ViewModel _viewmodel = Provider.of<ViewModel>(context);


    return Scaffold(
        backgroundColor: Color(0xff222222),
        appBar: AppBar(
          title: Text(
              "Kaydedilen Haberler"
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<String>>(
              future: _viewmodel.getSavedList(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    addAutomaticKeepAlives: true,
                    separatorBuilder: (context,i){
                      return Divider(
                        color: Colors.grey,
                      );
                    },
                    itemBuilder: (context,index){
                      //print("categori id:"+snapshot.data[index].categoriesId.toString());
                      return NewsCard(
                        newsId: snapshot.data[index],
                      );
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
                          style: TextStyle(
                              color: Colors.grey.shade200
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
          ),
        )
    );
  }


  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }


}
