import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/send_receive_bottomsheet.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/onboarding_screen.dart';
import 'package:flutter_application_1/screens/setting_screen.dart';
import 'package:flutter_application_1/screens/transaction_history_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/app_bottom_navigation_bar.dart';
import 'screens/home_screen.dart';
import "utils/injection_container.dart" as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context)=> WalletBloc(di.sl()))
        ],
        child: MaterialApp(
          title: 'TrueWallet',
          theme: ThemeData(
              colorScheme:
                  const ColorScheme.light(onPrimary: CustomColor.white)),
          home: OnboardingScreen(),
        ));
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
    List<Widget> screens = [
      const HomeScreen(),
      const TransactionHistory(),
      const Scaffold(
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
        children: screens,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
