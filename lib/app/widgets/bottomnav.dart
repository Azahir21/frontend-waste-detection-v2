import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/article/views/article_view.dart';
import 'package:frontend_waste_management/app/modules/camera/views/camera_view.dart';
import 'package:frontend_waste_management/app/modules/history/views/history_view.dart';
import 'package:frontend_waste_management/app/modules/home/views/home_view.dart';
import 'package:frontend_waste_management/app/modules/profile/views/profile_view.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
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

  // Note: The second screen is not used since tapping its nav item navigates to '/maps'.
  static const List<Widget> _screens = <Widget>[
    HomeView(),
    ArticleView(),
    HistoryView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    // If the Maps nav item (index 1) is tapped, navigate using Get.toNamed.
    if (index == 1) {
      Get.toNamed('/maps');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.labelSmallEmphasis("Garbage Type",
                            context: context),
                        VerticalGap.formMedium(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CustomIconButton.primary(
                                  iconName: AppIconName.pile,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.toNamed('/camera', arguments: true);
                                  },
                                  context: context,
                                  height: 75,
                                  width: 75,
                                ),
                                VerticalGap.formSmall(),
                                AppText.labelSmallEmphasis(
                                  AppLocalizations.of(context)!
                                      .illegal_dumping_site,
                                  context: context,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CustomIconButton.primary(
                                  iconName: AppIconName.pcs,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.toNamed('/camera', arguments: false);
                                  },
                                  context: context,
                                  height: 75,
                                  width: 75,
                                ),
                                VerticalGap.formSmall(),
                                AppText.labelSmallEmphasis(
                                  AppLocalizations.of(context)!.illegal_trash,
                                  context: context,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            backgroundColor: color.iconDefault,
            shape: const CircleBorder(),
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
          height: 60.0,
          child: Row(
            children: <Widget>[
              _buildNavItem(
                index: 0,
                iconName: AppIconName.home,
                label: AppLocalizations.of(context)!.dashboard,
              ),
              _buildNavItem(
                index: 1,
                iconName: AppIconName.map,
                label: AppLocalizations.of(context)!.maps,
              ),
              const SizedBox(width: 48.0),
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
