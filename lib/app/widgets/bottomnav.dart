import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/article/views/article_view.dart';
import 'package:frontend_waste_management/app/modules/history/views/history_view.dart';
import 'package:frontend_waste_management/app/modules/home/views/home_view.dart';
import 'package:frontend_waste_management/app/modules/profile/views/profile_view.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';

class BottomNavView extends StatefulWidget {
  BottomNavView({Key? key}) : super(key: key);

  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  static const List<Widget> _screens = <Widget>[
    HomeView(),
    ArticleView(),
    HistoryView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Set to a solid color
        elevation: 5, // Add elevation to make it stand out
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: color.iconActivate,
        unselectedItemColor: color.iconDisable,
        items: [
          BottomNavigationBarItem(
            icon: AppIcon.custom(
              appIconName: AppIconName.home,
              color:
                  _selectedIndex == 0 ? color.iconActivate : color.iconDefault,
              context: context,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: AppIcon.custom(
              appIconName: AppIconName.article,
              color:
                  _selectedIndex == 1 ? color.iconActivate : color.iconDefault,
              context: context,
            ),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: AppIcon.custom(
              appIconName: AppIconName.history,
              color:
                  _selectedIndex == 2 ? color.iconActivate : color.iconDefault,
              context: context,
            ),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: AppIcon.custom(
              appIconName: AppIconName.profile,
              color:
                  _selectedIndex == 3 ? color.iconActivate : color.iconDefault,
              context: context,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
