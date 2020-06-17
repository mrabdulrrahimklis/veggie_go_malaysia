import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:veggie_go_malaysia/datamodels/place.dart';

import '../../../../../app/locator.dart';
import '../../../../../app/router.dart';

class PlacesCardModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToPlaceDetails(Place place) {
    _navigationService.navigateTo(Routes.placeDetailsRoute, arguments: place);
  }
}