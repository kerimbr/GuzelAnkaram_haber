import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guzelankaram/models/category_model.dart';
import 'package:guzelankaram/pages/show_category_news.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:provider/provider.dart';


class CategoriesPage extends StatefulWidget {

  //CategoriesPage(Key key) : super(key:key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    ViewModel _viewmodel = Provider.of<ViewModel>(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<CategoryModel>>(
        future: _viewmodel.getAllCategories(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context,i){
                return SizedBox(height: 10);
              },
              itemBuilder: (context,index){
                return Card(
                  color: Colors.grey.shade800,
                  child: ListTile(
                    onTap: (){
                      Route r = MaterialPageRoute(
                        builder: (context)=>ShowCategoryNews(
                            categoryId: snapshot.data[index].id,
                            categoryName: snapshot.data[index].name
                        )
                      );
                      Navigator.of(context).push(r);
                    },
                    leading: Icon(
                      Entypo.list,
                      color: Colors.grey,
                    ),
                    trailing: Icon(
                      AntDesign.rightcircle,
                      color: Colors.orangeAccent,
                    ),
                    title: Text(
                      "${snapshot.data[index].name}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.grey.shade200,
                        fontSize: 20
                      ),
                    ),
                  ),
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
                    "Kategoriler Yükleniyor...",
                    style: TextStyle(
                        color: Colors.grey.shade200
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }
}
