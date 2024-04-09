import 'package:flutter/material.dart';
import 'package:status_viewer/src/utils/responsive/sizing_information.dart';
import 'package:status_viewer/src/utils/ui_utils.dart';

class ResponsiveUi extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation)? builder;

  const ResponsiveUi({Key? key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, boxSizing) {
        var sizingInformation = SizingInformation(
          orientation: mediaQuery.orientation,
          deviceScreenType: getDeviceType(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize: Size(boxSizing.maxWidth, boxSizing.maxHeight),
        );
        return builder!(context, sizingInformation);
      },
    );
  }
}
