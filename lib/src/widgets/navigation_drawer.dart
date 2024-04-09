import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_viewer/src/utils/constants.dart';
import 'package:status_viewer/src/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MyNavigationDrawer extends StatelessWidget {
  final _menutextcolor = TextStyle(
    color: Colors.black,
    fontSize: ItemSize.fontSize(14),
    fontWeight: FontWeight.w500,
  );
  final _iconcolor = const IconThemeData(
    color: Color(0xff757575),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.4,
                  image: AssetImage(ConstantImages.backgroundTransPath))),
          accountName: Text(
            "WhatsApp Status viewer",
            style: TextStyle(
              fontSize: ItemSize.fontSize(20),
            ),
          ),
          accountEmail: const Text("Download WhatsApp Status"),
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: const Icon(Icons.share),
          ),
          title: Text("Share App", style: _menutextcolor),
          onTap: () {
            // you can modify message if you want.
            Share.share(
                "\nAn App to help you Download WhatsApp Status Photos and WhatsApp Video Status from your contacts. \n\n  \nDownload Now \n https://bit.ly/3vTEQHc");
          },
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: const Icon(Icons.rate_review),
          ),
          title: Text("Rate and Review", style: _menutextcolor),
          onTap: () async {
            Navigator.of(context).pop();
            // you can update this link with your app link
            const url =
                'https://play.google.com/store/apps/details?id=com.noqtechnologies.statusviewer';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not open App';
            }
          },
        ),
        ListTile(
          leading: IconTheme(
            data: _iconcolor,
            child: const Icon(Icons.security),
          ),
          title: Text("Privacy Policy", style: _menutextcolor),
          onTap: () async {
            Navigator.of(context).pop();
            // add privacy policy url
            const url = 'https://noqtech.policy.tlpcialc.pw/';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not open App';
            }
          },
        ),
      ],
    );
  }
}
