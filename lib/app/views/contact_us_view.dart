import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase_mobile_flutter/app/data/app_data.dart';

class ContactUsView extends GetView {
  const ContactUsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: ContactUs(
            logo: const AssetImage(AppAssets.icon),
            email: 'rohitsangwan647@gmail.com',
            companyName: 'Rohit Sangwan',
            companyFontSize: 28,
            companyFontWeight: FontWeight.w400,
            taglineFontWeight: FontWeight.w400,
            dividerThickness: 2,
            githubUserName: 'rohitsangwan01',
            linkedinURL: 'https://www.linkedin.com/in/rohit-sangwan-5282761b3/',
            twitterHandle: "RohitSa93573160",
            instagram: "rohit.sangwan01",
            textColor: Theme.of(context).colorScheme.onBackground,
            cardColor: Theme.of(context).colorScheme.background,
            taglineColor: Theme.of(context).secondaryHeaderColor,
            companyColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
