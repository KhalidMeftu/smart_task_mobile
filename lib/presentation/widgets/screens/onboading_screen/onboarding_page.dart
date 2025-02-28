import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_strings/app_strings.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/login_screen/login_page.dart';
import 'component/onboarding_contents.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = [
    SmartTaskAppColors.onboardIntialColor,
    SmartTaskAppColors.onboardSecondColor,
    SmartTaskAppColors.onboardThirdColor,
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            contents[i].image,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: SmartTaskFonts.medium().copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: SmartTaskAppColors.blackColor),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          contents[i].desc,
                          style: SmartTaskFonts.medium().copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              color: SmartTaskAppColors.blackColor),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SmartTaskAppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20),
                              textStyle: TextStyle(fontSize: 13),
                            ),
                            child: Text(
                              SmartStrings.start,
                              style: SmartTaskFonts.medium().copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: SmartTaskAppColors.whiteColor),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _controller.jumpToPage(2);
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: SmartTaskFonts.medium().copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                                child: Text(
                                  SmartStrings.skip,
                                  style: SmartTaskFonts.medium().copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: SmartTaskAppColors.primaryColor),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      SmartTaskAppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  textStyle: SmartTaskFonts.medium().copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                                child: Text(SmartStrings.next,
                                    style: SmartTaskFonts.medium().copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: SmartTaskAppColors.whiteColor)),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
