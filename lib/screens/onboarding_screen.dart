import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_appbar.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/create_password_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/custom_button.dart';
import '../components/custom_gradient_text.dart';
import '../components/custom_text.dart';
import '../components/custom_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late WalletBloc walletBloc;
  bool newWalletButtonPressed = false;
  @override
  void initState() {
    walletBloc = BlocProvider.of<WalletBloc>(context);
    super.initState();
  }

  final List<String> _images = [
    ImagePath.onboardingOne,
    ImagePath.onboardingTwo,
    ImagePath.onboardingThree,
    ImagePath.onboardingFour,
  ];

  final List<String> _titles = [
    'Manage your',
    'Manage your',
    'Cryptocurrency is the',
    'Wallet Setup',
  ];

  final List<String> _subtitles = [
    'Digital Assets',
    'Digital Assets',
    'Future',
    '',
  ];

  final List<String> _descriptions = [
    'Store, Spend and send digital assets like tokens, ethereum and blockfit',
    'Store, Spend and send digital assets like tokens, ethereum and blockfit',
    'Cryptocurrency is the most very secure in the world',
    'Import an existing wallet or create a new one to get started.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppbar(
          showCenterWidget: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.asset(
                            _images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(_images.length, (i) {
                                return GestureDetector(
                                  onTap: () {
                                    _pageController.animateToPage(
                                      i,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                    width: _currentPage == i ? 12.0 : 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == i ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            if (_titles[index] == 'Wallet Setup')
                              CustomGradientText(
                                text: _titles[index],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else if (_titles[index] ==
                                'Cryptocurrency is the')
                              RichText(
                                text: TextSpan(
                                  style: CustomTextStyles.textSubHeading(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    const WidgetSpan(
                                      alignment:
                                          PlaceholderAlignment.middle,
                                      child: CustomGradientText(
                                        text: 'Cryptocurrency ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'is the',
                                      style:
                                          CustomTextStyles.textSubHeading(
                                              color: Colors.black,
                                              fontWeight:
                                                  FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Text(
                                _titles[index],
                                style: CustomTextStyles.textSubHeading(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (_subtitles[index].isNotEmpty)
                              if (_titles[index] ==
                                  'Cryptocurrency is the')
                                Text(
                                  _subtitles[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else if (_subtitles[index] ==
                                  'Digital Assets')
                                CustomGradientText(
                                  text: _subtitles[index],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                CustomText(
                                  text: _subtitles[index],
                                  style: CustomTextStyles.textSubHeading(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            const SizedBox(height: 8),
                            CustomText(
                              text: _descriptions[index],
                              style: CustomTextStyles.textCommon(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: index == 3
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            text: 'Import',
                                            onPressed: () {},
                                            isGradient: false,
                                            backgroundColor:
                                                CustomColor.grey,
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10,
                                                vertical: 10),
                                            textStyle: CustomTextStyles
                                                .textCommon(
                                                    color: CustomColor
                                                        .white),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomButton(
                                            text: 'Create New Wallet',
                                            onPressed: () async => {
                                              walletBloc.add(CreateWallet()),
                                              Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CreatePasswordScreen()))
                                            },
                                            isGradient: true,
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 8,
                                                vertical: 12),
                                            textStyle: CustomTextStyles
                                                .textSubLabel(
                                                    color: CustomColor
                                                        .white),
                                          ),
                                        ),
                                      ],
                                    )
                                  : CustomButton(
                                      text: 'Get Started',
                                      onPressed: _nextPage,
                                      isGradient: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 10),
                                      textStyle:
                                          CustomTextStyles.textSubHeading(
                                              color: CustomColor.white),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
