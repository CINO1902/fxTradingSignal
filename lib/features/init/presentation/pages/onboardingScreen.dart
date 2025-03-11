import 'package:flutter/material.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/registration.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({Key? key}) : super(key: key);

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  final _controller = PageController();
  bool islastPage = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.15,
            ),
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  islastPage = index == 2;
                });
              },
              children: const [
                buildPage2(
                  title: "Expert Trading Signals",
                  getImage: "assets/images/onboardingImage.png",
                  subText:
                      "Access verified trading signals from top market experts, all in one place.",
                ),
                buildPage2(
                  title: "Copy With Confidence",
                  getImage: "assets/images/onboardingImage.png",
                  subText:
                      "Follow and copy signals with real-time notifications. No trading experience needed.",
                ),
                buildPage2(
                  title: "Track Your Success",
                  getImage: "assets/images/onboardingImage.png",
                  subText:
                      "Monitor your copied signals and performance with our easy-to-use dashboard.",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.kWhite,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Container(
          //color: Colors.red,
          margin: EdgeInsets.only(
            bottom: 40,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  onDotClicked: (index) => _controller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  effect: CustomizableEffect(
                    activeDotDecoration: DotDecoration(
                      width: 33,
                      height: 8,
                      color: AppColors.kprimaryColor300,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    dotDecoration: DotDecoration(
                      width: 8,
                      height: 8,
                      color: AppColors.kgrayColor75,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    spacing: 8.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  islastPage
                      ? context.pushNamed('register')
                      : _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                  if (islastPage) {
                    final pref = await SharedPreferences.getInstance();
                    pref.setBool('seen_onboarding', true);
                  }
                },
                child: Container(
                    height: 54,
                    width: 305,
                    decoration: BoxDecoration(
                        color: AppColors.kprimaryColor300,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: Text(islastPage ? 'Get Started' : 'Next',
                          style: TextStyle(
                              color: AppColors.kWhite,
                              fontWeight: FontWeight.bold)),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class buildPage2 extends StatelessWidget {
  const buildPage2({
    Key? key,
    required this.title,
    required this.subText,
    required this.getImage,
  }) : super(key: key);

  final String title;
  final String subText;
  final String getImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,

      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Image.asset(
            "assets/images/onboardingImage.png",
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.05,
            child: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            //color: Colors.black,
            width: MediaQuery.of(context).size.width * 0.9,

            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              subText,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //SizedBox(height: 40,),
        ],
      ),
    );
  }
}
