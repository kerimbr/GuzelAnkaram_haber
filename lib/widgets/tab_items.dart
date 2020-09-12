import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';

enum TabItem{
 AnaSayfa,
 Kategoriler,
 Kaydedilenler
}


class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.AnaSayfa : TabItemData("Ana Sayfa", FontAwesome.newspaper_o),
    TabItem.Kategoriler : TabItemData("Kategoriler",Entypo.list),
    TabItem.Kaydedilenler : TabItemData("Kaydedilenler", AntDesign.pushpino)
  };
}