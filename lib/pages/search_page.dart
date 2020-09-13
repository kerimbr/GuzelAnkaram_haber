import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guzelankaram/models/search_model.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:guzelankaram/widgets/news_card.dart';
import 'package:provider/provider.dart';



class SearchPage extends StatefulWidget {

  // Arama Sayfası

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  GlobalKey<FormState> _searchForm = GlobalKey();

  String searchText="";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ViewModel _viewmodel = Provider.of<ViewModel>(context);


    return Scaffold(
      backgroundColor: Color(0xff222222),
      appBar: AppBar(
        title: Text(
            "Haber Ara",
          style: TextStyle(
            fontSize: 24
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),

          // Search Bar
          Form(
            key: _searchForm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:30),
              child: TextFormField(
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade200
                ),
                validator: _searchValid,
                onSaved: (value){
                  searchText = value;
                },
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "Haber Ara",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey.shade200
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      FlutterIcons.send_o_faw,
                      color: Colors.orange,
                    ),
                    onPressed: (){
                      _searchButton();
                    },
                  ),


                  fillColor: Colors.grey.shade200,
                  focusColor: Colors.grey.shade200,
                  hoverColor: Colors.grey.shade200,

                  disabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),

                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              child: FutureBuilder<List<SearchModel>>(
                future: _searchFuture(),
                builder: (context,snapshot){
                  if(snapshot.hasData && loading==false){

                    return ListView.separated(
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context,i){
                        return Divider();
                      },
                      itemBuilder: (context,index){
                        return NewsCard(newsId: snapshot.data[index].id);
                      },
                    );
                  }else{
                    return Center(
                      child: CupertinoActivityIndicator(
                        radius: 50,
                      )
                    );
                  }
                },
              ),
            ),
          )

        ],
      ),
    );
  }



  String _searchValid(String value) {
    if(value.length>0){
      return null;
    }else{
      return "Geçerli Metin Girin!";
    }
  }

  void _searchButton() {
    if(_searchForm.currentState.validate()){
      setState(() {
        _searchForm.currentState.save();
      });
      print(searchText);
    }
  }

  Future<List<SearchModel>> _searchFuture() async{

    loading = true;

    ViewModel _viewmodel = Provider.of<ViewModel>(context,listen:false);

    List<SearchModel> searchResult = [];

    searchResult  = await _viewmodel.getSearchResult(searchText);

    loading = false;
    return searchResult;

  }
}
