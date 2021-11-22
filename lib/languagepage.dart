import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class LanguageSetupPage extends StatefulWidget {
  @override
  _LanguageSetupPageState createState() => _LanguageSetupPageState();
}

class _LanguageSetupPageState extends State<LanguageSetupPage> {
  @override
  Widget build(BuildContext context) {
    var store1 = Provider.of<Store>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          store1.setting.tr(),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                'Language Setup',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ).tr(),
            ),
            Option(
                context: context,
                title: 'ภาษาไทย',
                subtitle: 'สวัสดี',
                //locale: context.supportedLocales[1]
                locale: context.supportedLocales[1]),
            NL(),
            Option(
                context: context,
                title: 'English',
                subtitle: 'Hello',
                locale:
                    context.supportedLocales[0] //BuildContext extension method
                //locale: EasyLocalization.of(context)!.supportedLocales[0]
                ),
          ],
        ),
      ),
    );
  }

  Container NL() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Divider(
          color: Colors.grey,
        ),
      );

  Container Option({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Locale locale,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: ListTile(
          dense: true,
          // isThreeLine: true,
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          onTap: () {
            print(locale.toString());
            context.setLocale(locale);
            //Navigator.pop(context);
          }),
    );
  }
}
