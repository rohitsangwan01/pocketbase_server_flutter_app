import 'package:contactus/contactus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase_mobile_flutter/app/data/app_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

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
                textColor: Theme.of(context).colorScheme.onSurface,
                cardColor: Theme.of(context).colorScheme.surface,
                taglineColor: Theme.of(context).colorScheme.onSurface,
                companyColor: Theme.of(context).colorScheme.onSurface,
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
