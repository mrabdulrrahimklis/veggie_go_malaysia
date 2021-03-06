import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veggie_go_malaysia/ui/views/home/home_view.dart';
import 'package:veggie_go_malaysia/ui/views/home/widgets/text_search/text_search.dart';
import 'package:veggie_go_malaysia/ui/views/restaurant_details/restaurant_details_view.dart';
import 'package:veggie_go_malaysia/ui/views/startup/startup_view.dart';

abstract class Routes {
  static const startupViewRoute = '/';
  static const homeViewRoute = '/home';
  static const searchViewRoute = '/search';
  static const retaurantDetailsRoute = '/restaurant_details';
}

class Router {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startupViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => StartupView(),
          settings: settings,
        );
      case Routes.homeViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(),
          settings: settings,
        );
      case Routes.searchViewRoute:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => SearchView(),
          settings: settings,
        );
      case Routes.retaurantDetailsRoute:
        return CupertinoPageRoute<dynamic>(
          builder: (context) => RestaurantDetailsView(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// borrowed from auto_route:
// returns an error page routes with a helper message.
PageRoute unknownRoutePage(String routeName) => CupertinoPageRoute(
      builder: (ctx) => Scaffold(
        body: Container(
          color: Colors.redAccent,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Text(
                  routeName == '/'
                      ? 'Initial route not found! \n did you forget to annotate your home page with @initial or @MaterialRoute(initial:true)?'
                      : 'Route name $routeName is not found!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              OutlineButton.icon(
                label: Text('Back'),
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        ),
      ),
    );
