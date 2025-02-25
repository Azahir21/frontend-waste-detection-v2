import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/article/views/article_view.dart';
import 'package:frontend_waste_management/app/modules/camera/views/camera_view.dart';
import 'package:frontend_waste_management/app/modules/history/views/history_view.dart';
import 'package:frontend_waste_management/app/modules/home/views/home_view.dart';
import 'package:frontend_waste_management/app/modules/profile/views/profile_view.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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

  Widget _buildNavItem({
    required int index,
    required AppIconName iconName,
    required String label,
  }) {
    var color = Theme.of(context).appColors;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Padding(
          // Reduced vertical padding to help fit within the fixed height
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon.custom(
                appIconName: iconName,
                color: _selectedIndex == index
                    ? color.iconActivate
                    : color.iconDefault,
                context: context,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: _selectedIndex == index
                      ? color.iconActivate
                      : color.iconDisable,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: SizedBox(
        width: 64.0,
        height: 64.0,
        child: FittedBox(
          child: FloatingActionButton(
            foregroundColor: color.iconActivate,
            onPressed: () {
              Get.toNamed('/camera');
            },
            backgroundColor: color.iconDefault,
            shape: CircleBorder(), // Enforces a circular shape explicitly
            child: AppIcon.custom(
              appIconName: AppIconName.camera,
              color: Theme.of(context).appColors.iconActivate,
              context: context,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 5,
        child: Container(
          // Set a fixed height to avoid overflow
          height: 60.0,
          child: Row(
            children: <Widget>[
              // Left side navigation items
              _buildNavItem(
                index: 0,
                iconName: AppIconName.home,
                label: AppLocalizations.of(context)!.dashboard,
              ),
              _buildNavItem(
                index: 1,
                iconName: AppIconName.article,
                label: AppLocalizations.of(context)!.article,
              ),
              // Middle gap for the FAB
              const SizedBox(width: 48.0),
              // Right side navigation items
              _buildNavItem(
                index: 2,
                iconName: AppIconName.history,
                label: AppLocalizations.of(context)!.history,
              ),
              _buildNavItem(
                index: 3,
                iconName: AppIconName.profile,
                label: AppLocalizations.of(context)!.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
