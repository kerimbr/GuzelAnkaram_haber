import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guzelankaram/notification_handler.dart';
import 'package:guzelankaram/pages/categories_page.dart';
import 'package:guzelankaram/pages/news_page.dart';
import 'package:guzelankaram/pages/saves_page.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';
import 'package:guzelankaram/widgets/my_custom_bottom_navigation.dart';
import 'package:guzelankaram/widgets/tab_items.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  TabItem currentTab = TabItem.AnaSayfa;

  Map<TabItem, Widget> allPagesWidget() {
    return  {
      TabItem.AnaSayfa : NewsPage(),
      TabItem.Kategoriler : CategoriesPage(),
      TabItem.Kaydedilenler : SavesPage()
    };
  }


  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.AnaSayfa : GlobalKey<NavigatorState>(),
    TabItem.Kategoriler : GlobalKey<NavigatorState>(),
    TabItem.Kaydedilenler : GlobalKey<NavigatorState>(),

  };


  @override
  void initState() {
    super.initState();

    NotificationHandler().initializeFCMNotification();
  }


  @override
  Widget build(BuildContext context) {
    ViewModel _viewmodel = Provider.of<ViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xff222222),

      body: WillPopScope(
        onWillPop: () async {
          if (await navigatorKeys[currentTab].currentState.maybePop()) {
            return false;
          } else {
            return false;
          }
        },
        child: MyCustomBottomNavigation(
          currentTab: currentTab,
          navigatorKeys: navigatorKeys,
          buildPage: allPagesWidget(),
          onSelectedTab: (selected){
            setState(() {
              currentTab = selected;
            });
          },
        ),
      ),

    );
  }


}
