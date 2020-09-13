import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guzelankaram/widgets/tab_items.dart';

class MyCustomBottomNavigation extends StatelessWidget {

  /*
  * BottomNavigationButton'lar için özelleştirilmiş Widget sınıfı.
  * HomePage'de Stack Yapısını oluşturur.
  * */


  const MyCustomBottomNavigation({
    Key key, @required this.currentTab,
    @required this.onSelectedTab,
    @required this.buildPage,
    @required this.navigatorKeys
  })
      : super(key: key);


  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem,Widget> buildPage;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Color(0xff222222),
      tabBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Colors.deepOrangeAccent,
        inactiveColor: Colors.grey,
        iconSize: 30,
        items: [
          _buildNavItem(TabItem.AnaSayfa),
          _buildNavItem(TabItem.Kategoriler),
          _buildNavItem(TabItem.Kaydedilenler),
        ],
        onTap: (index)=>onSelectedTab(TabItem.values[index]),
      ),

      tabBuilder: (context,index){

        final showItem = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[showItem],
          builder: (context){
            return buildPage[showItem];
          },
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(TabItem tabItem){

    final currentTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(
        currentTab.icon,
      ),
      title: Text(
        currentTab.title
      )
    );
  }

}
