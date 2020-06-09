import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:veggie_go_malaysia/constants/colors.dart';
import 'package:veggie_go_malaysia/datamodels/announcement.dart';
import 'package:veggie_go_malaysia/datamodels/restaurant.dart';
import 'package:veggie_go_malaysia/ui/views/home/home_viewmodel.dart';
import 'package:veggie_go_malaysia/ui/views/home/widgets/location_bar.dart';
import 'package:veggie_go_malaysia/ui/views/home/widgets/quick_search.dart';

import '../../../constants/colors.dart';
import 'widgets/quick_search.dart';
import 'widgets/restaurant_card/restaurant_card.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String dropdownValue = 'Malaysia'; // TODO: handle in viewmodel instead
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: ThemeColors.background,
        body: SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              floating: true,
              backgroundColor: ThemeColors.background,
              title: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(width: 30.w),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Container(
                      height: 25.h,
                      child: Image.asset(
                        'assets/images/arrow_down.png',
                      ),
                    ),
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black),
                    underline: Container(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Malaysia', 'Singapore']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: ThemeColors.background,
              title: Row(
                children: <Widget>[
                  Chip(
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Restaurants',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    backgroundColor: ThemeColors.brightGreen,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Chip(
                    backgroundColor: Colors.white,
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Stores',
                        style: TextStyle(
                            fontFamily: 'Lato', color: ThemeColors.brightGreen),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _SearchBar(model),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 80.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  QuickSearch(),
                  SizedBox(height: 20.h),
                ]),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 80.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 20.h),
                  _AnnouncementCarousel(model.announcements),
                ]),
              ),
            ),
          ]),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final HomeViewModel model;
  _SearchBar(this.model);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ThemeColors.background,
      title: Row(
        children: <Widget>[
          Expanded(child: LocationSelector(model)),
          SizedBox(width: 40.w),
          IconButton(
            icon: Image.asset(
              'assets/images/filter.png',
              height: 70.h,
            ),
            onPressed: () {},
          ),
        ],
      ),
      pinned: true,
      elevation: 0.0,
      expandedHeight: 220.h,
    );
  }
}

class _AnnouncementCarousel extends StatelessWidget {
  final List<Announcement> announcements;
  _AnnouncementCarousel(this.announcements);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: announcements.length,
      itemBuilder: (BuildContext context, int itemIndex) {
        var item = announcements[itemIndex];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey[200],
                    offset: Offset(0, 2))
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(40.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: <Widget>[
                          Text(
                            item.title,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            item.previewContent,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: CachedNetworkImage(imageUrl: item.imageUrl),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 400.h,
        viewportFraction: 1,
        autoPlay: true,
        enableInfiniteScroll: false,
        autoPlayInterval: Duration(seconds: 10),
        autoPlayAnimationDuration: Duration(milliseconds: 500),
        enlargeCenterPage: true,
        reverse: false,
      ),
    );
  }
}

class _FilterResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.w),
      child: Row(
        children: <Widget>[
          Text(
            'Results',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              //TODO tap to open dropdown filter menu
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey6.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 50.w),
                child: Row(
                  children: <Widget>[
                    Text('Nearest'),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Icon(
            Icons.filter_list,
            color: ThemeColors.brightGreen,
          )
        ],
      ),
    );
  }
}

class _ResultsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RestaurantCard(
          restaurant: Restaurant(name: '  ', address: '  ', openingHours: {
            'open': '  ',
            'close': ' ',
          }),
        ),
        RestaurantCard(
          restaurant: Restaurant(
              mainPhoto: NetworkImage(
                  'https://z8e5v5j3.stackpathcdn.com/wp-content/uploads/2019/01/SkyAvenue-Food-Wow.jpg'),
              name: 'Sky Avenue',
              address: 'New york City Yay',
              rating: 5.0,
              openingHours: {
                'open': '12pm',
                'close': '4pm ',
              }),
        ),
      ],
    );
  }
}
