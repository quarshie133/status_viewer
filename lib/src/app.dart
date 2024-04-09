import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:status_viewer/src/screens/photo_screen.dart';
import 'package:status_viewer/src/screens/video_screen.dart';
import 'package:status_viewer/src/utils/constants.dart';
import 'package:status_viewer/src/utils/responsive/base_widget.dart';
import 'package:status_viewer/src/utils/theme.dart';
import 'package:status_viewer/src/widgets/navigation_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  static final List<Tab> _tabs = <Tab>[
    Tab(
      iconMargin: const EdgeInsets.all(100),
      child: Icon(
        Icons.photo_outlined,
        size: ItemSize.fontSize(29),
      ),
    ),
    Tab(
      iconMargin: const EdgeInsets.all(100),
      child: Icon(
        Icons.video_collection_outlined,
        size: ItemSize.fontSize(29),
      ),
    )
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUi(builder: (context, sizingInformation) {
      return SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: ItemSize.spaceHeight(10),
                    floating: true,
                    pinned: false,
                    stretch: true,
                    snap: false,
                    centerTitle: false,
                    leading: Builder(
                      builder: (context) {
                        return IconButton(
                          icon: SvgPicture.asset(
                            ConstantImages.menuIconPath,
                            fit: BoxFit.cover,
                            height: ItemSize.fontSize(22),
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        );
                      },
                    ),
                    title: Text(
                      "Status viewer",
                      style: TextStyle(fontSize: ItemSize.fontSize(18)),
                    ),
                    flexibleSpace: const FlexibleSpaceBar(
                        background: Opacity(
                      opacity: 0.4,
                      child: Image(
                        image: AssetImage(ConstantImages.backgroundTransPath),
                        fit: BoxFit.cover,
                      ),
                    )),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        indicatorColor: Colors.white,
                        controller: _tabController,
                        tabs: _tabs,
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [PhotoView(), VideoListView()],
              ),
            ),
          ),
          drawer: Drawer(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(ItemSize.radius(30)),
                    bottomRight: Radius.circular(ItemSize.radius(30)))),
            child: MyNavigationDrawer(),
          ),
        ),
      );
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: const DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.4,
              image: AssetImage(ConstantImages.backgroundTransPath))),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
