import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';

import '../components/custom_gradient_indicator.dart';
import '../components/custom_text_field.dart';
import '../constants/custom_color.dart';
import '../constants/image_path.dart';

class ExportPrivateKeyScreen extends StatefulWidget {
  const ExportPrivateKeyScreen({super.key});

  @override
  State<ExportPrivateKeyScreen> createState() => _ExportPrivateKeyScreenState();
}

class _ExportPrivateKeyScreenState extends State<ExportPrivateKeyScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _passwordController = TextEditingController();
  late TabController _tabController;

  bool showTabBarView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomHomeAppbar(
          showBackWidget: true,
          showTrailingWidget: true,
          onTrailingTap: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CustomGradientText(
                    text: 'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: CustomColor.grey,
                ),
                const SizedBox(width: 5),
                const CustomGradientText(
                  text: 'Export Private Key',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            CustomText(
                text: 'Save it somewhere safe and secret',
                style: CustomTextStyles.textCommon(color: CustomColor.grey)),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: CustomColor.lightRed,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(color: CustomColor.red, width: 1),
              ),
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.eyeRed,
                      height: 40,
                      width: 55,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomText(
                        text:
                            'Never disclose this key. Anyone with your private key can fully control your account, including transferring away any of your funds',
                        maxLines: 4,
                        softWrap: true,
                        style: CustomTextStyles.textCommon(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!showTabBarView) ...[
              // Initial Screen
              CustomText(
                text: 'Enter your password to continue',
                style: CustomTextStyles.textCommon(
                  color: CustomColor.grey,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                isFullSize: true,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 10),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomButton(
                      text: 'Continue',
                      onPressed: () {
                        setState(() {
                          showTabBarView = true;
                        });
                      },
                      isGradient: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 10),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Second Screen with TabBar and TabBarView
              TabBar(
                controller: _tabController,
                indicator: CustomGradientIndicator(
                  gradient: const LinearGradient(
                      colors: [CustomColor.green, CustomColor.blue]),
                  height: 4.0,
                  screenWidth: MediaQuery.of(context).size.width,
                ),
                unselectedLabelColor: CustomColor.grey,
                tabs: [
                  Tab(
                    child: AnimatedBuilder(
                      animation: _tabController.animation!,
                      builder: (context, child) {
                        bool isSelected = _tabController.index == 0;
                        return isSelected
                            ? const CustomGradientText(
                                text: 'Text',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                'Text',
                                style: CustomTextStyles.textSubHeading(
                                  color: CustomColor.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                      },
                    ),
                  ),
                  Tab(
                    child: AnimatedBuilder(
                      animation: _tabController.animation!,
                      builder: (context, child) {
                        bool isSelected = _tabController.index == 1;
                        return isSelected
                            ? const CustomGradientText(
                                text: 'QR Code',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                'QR Code',
                                style: CustomTextStyles.textSubHeading(
                                  color: CustomColor.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1 Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        CustomText(
                          text: 'Your Private Key',
                          style: CustomTextStyles.textCommon(
                            color: CustomColor.black,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    text:
                                        '52e81c606dd60cf84517cfab c2965a38b822714136400255 b0e9055284f257a8',
                                    softWrap: true,
                                    maxLines: 3,
                                    style: CustomTextStyles.textSubHeading(
                                        color: CustomColor.grey),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImagePath.copyIcon,
                                        height: 12,
                                        width: 12,
                                      ),
                                      CustomText(
                                        text: 'Copy',
                                        style: CustomTextStyles.textSubLabel(
                                            color: CustomColor.blue),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: CustomButton(
                              isGradient: true,
                              text: 'Done',
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10),
                              onPressed: () {}),
                        )
                      ],
                    ),
                    // Tab 2 Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(child: Text('Qr code here')),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: CustomButton(
                              isGradient: true,
                              text: 'Done',
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10),
                              onPressed: () {}),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
