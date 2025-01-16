import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';

import '../components/custom_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';
import '../constants/image_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: CustomHomeAppbar(
            showBackWidget: true,
            showTrailingWidget: true,
            onTrailingTap: () {},
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColor.white,
                  border: Border.all(
                    color: CustomColor.offWhite,
                    width: 2,
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: CustomColor.lightBlue,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CustomText(
                              text: 'Account 1',
                              style: CustomTextStyles.textCommon(),
                            ),
                          ],
                        ),
                        Transform.rotate(
                          angle: 90 * (3.14 / 180),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: CustomColor.offWhite,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      height: 5,
                      color: CustomColor.offWhite,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Address : ',
                          style: CustomTextStyles.textSubLabel(
                              color: CustomColor.black),
                        ),
                        Container(
                            height: 20,
                            decoration: BoxDecoration(
                                color: CustomColor.lightBlue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                const Text(
                                  'user address',
                                  style: TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Image.asset(
                                  ImagePath.copyIcon,
                                  height: 10,
                                  width: 10,
                                )
                              ],
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomText(
                      text: '\$ 145.25',
                      style: CustomTextStyles.textSubTitle(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: '+\$5 (+3.14%)',
                      style: CustomTextStyles.textLabel(
                          color: CustomColor.grey,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: CustomColor.blue, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        CustomText(
                          text: 'Portfolio',
                          style: CustomTextStyles.textLabel(
                              color: CustomColor.blue),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          ImagePath.navigatorIcon,
                          height: 10,
                          width: 10,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 120,
              child: ListView.builder(itemBuilder: (context, index) {
                return _buildTransactionCard(ImagePath.copyIcon, 'Fit24',
                    '1.43', '56.37', '12', 'Fit24');
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: CustomButton(
                text: 'Buy',
                onPressed: () {},
                isGradient: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomText(
              text: 'Actions',
              style: CustomTextStyles.textSubTitle(color: CustomColor.black),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        ImagePath.receiveImage,
                        height: 120,
                        width: 100,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        ImagePath.sendImage,
                        height: 120,
                        width: 100,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    String imagePath,
    String title,
    String subTitle,
    String amount,
    String increasedAmount,
    String currency,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 33,
                      width: 33,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fill,
                      )),
                  Container(
                    width: 80,
                    child: Column(
                      children: [
                        CustomText(
                          text: title,
                          style: CustomTextStyles.textCommon(
                              fontWeight: FontWeight.bold,
                              color: CustomColor.black),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        CustomText(
                          text: '+$subTitle%',
                          style: CustomTextStyles.textSubLabel(
                              color: CustomColor.green),
                        )
                      ],
                    ),
                  ),
                  CustomText(
                    text: '.Stake',
                    style: CustomTextStyles.textLabel(
                      color: CustomColor.blue,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomText(
                    text: '\$ $amount',
                    style: CustomTextStyles.textCommon(
                      color: CustomColor.black,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  CustomText(
                    text: '$increasedAmount {$currency}',
                    style: CustomTextStyles.textLabel(
                      color: CustomColor.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
