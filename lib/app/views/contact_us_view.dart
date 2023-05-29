import 'package:contactus/contactus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase_mobile_flutter/app/data/app_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends GetView {
  const ContactUsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            children: [
              ContactUs(
                logo: const AssetImage(AppAssets.icon),
                email: 'rohitsangwan647@gmail.com',
                companyName: 'Rohit Sangwan',
                companyFontSize: 28,
                companyFontWeight: FontWeight.w400,
                taglineFontWeight: FontWeight.w300,
                dividerThickness: 2,
                githubUserName: 'rohitsangwan01',
                linkedinURL:
                    'https://www.linkedin.com/in/rohit-sangwan-5282761b3/',
                instagram: "rohit.sangwan01",
                textColor: Theme.of(context).colorScheme.onBackground,
                cardColor: Theme.of(context).colorScheme.background,
                taglineColor: Theme.of(context).colorScheme.onBackground,
                companyColor: Theme.of(context).colorScheme.onBackground,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            "I am not owner of pocketbase, this mobile app is based on ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'POCKETBASE',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(
                              Uri.parse(AppUtils.pocketbaseUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                      ),
                      const TextSpan(
                        text: " framework",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
