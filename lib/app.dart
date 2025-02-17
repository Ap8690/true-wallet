import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/send_receive_bottomsheet.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_1/presentation/networks/bloc/networks_bloc.dart';
import 'package:flutter_application_1/presentation/send/bloc/send_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/explore_website_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/onboarding_screen.dart';
import 'package:flutter_application_1/presentation/send/view/transfer_screen.dart';
import 'package:flutter_application_1/screens/setting_screen.dart';
import 'package:flutter_application_1/screens/transaction_history_screen.dart';
import 'package:flutter_application_1/services/sharedpref/preference_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'screens/app_bottom_navigation_bar.dart';
import 'screens/home_screen.dart';
import "utils/injection_container.dart" as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GetIt getIt = GetIt.I;
  static PreferenceService preferenceService = getIt<PreferenceService>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => WalletBloc(di.sl(),),),
          BlocProvider(
              create: (BuildContext context) => AuthBloc(di.sl(), di.sl(),),),
               BlocProvider(create: (BuildContext context) => SendBloc(di.sl(),  BlocProvider.of<WalletBloc>(context),)),
                BlocProvider(
          create: (BuildContext context) => NetworksBloc(di.sl(), di.sl()),
        ),
        ],
        child: MaterialApp(
          title: 'TrueWallet',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme:
                  const ColorScheme.light(onPrimary: CustomColor.white)),
          home: preferenceService.isLoggedIn
              ? const LoginScreen()
              : OnboardingScreen(),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _selectedIndex == 0 ? const HomeScreen() : Container(),
          _selectedIndex == 1 ? const TransactionHistory() : Container(),
          _selectedIndex == 2 ? const TransferScreen() : Container(),
          _selectedIndex == 3 ? const ExploreWebsiteScreen() : Container(),
          _selectedIndex == 4 ? const SettingScreen() : Container(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
