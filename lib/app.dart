import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/send_receive_bottomsheet.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/screens/onboarding_screen.dart';
import 'package:flutter_application_1/screens/setting_screen.dart';
import 'package:flutter_application_1/screens/transaction_history_screen.dart';

import 'screens/app_bottom_navigation_bar.dart';
import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrueWallet',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(onPrimary: CustomColor.white)),
      home: OnboardingScreen(),
    );
  }
}

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 2) {
        SendReceiveBottomsheet.show(
          context,
          "Choose an Action",
          [
            {"icon": "path_to_icon1", "label": "Send"},
            {"icon": "path_to_icon2", "label": "Receive"},
          ],
          (selectedItem) {
            print("Selected: $selectedItem");
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> _screens = [
      const HomeScreen(),
      const TransactionHistory(),
      Scaffold(
        body: Center(
          child: Text(
            "Send/Receive Screen",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      const SettingScreen(),
      const SettingScreen()
    ];
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
