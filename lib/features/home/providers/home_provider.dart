import 'package:country_pickers/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/home/controller/home_controller.dart';
import 'package:register_visa_web_app/features/home/domain/package_response.dart';
import 'package:register_visa_web_app/features/home/providers/home_state.dart';

final homeProvider = AsyncNotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

// Provider for filtered list to make it reactive
final filteredListProvider =
    NotifierProvider<FilteredListNotifier, List<CountryPackage>>(
      FilteredListNotifier.new,
    );

class FilteredListNotifier extends Notifier<List<CountryPackage>> {
  @override
  List<CountryPackage> build() => [];

  void updateList(List<CountryPackage> newList) {
    state = newList;
  }

  void clearList() {
    state = [];
  }
}

// Provider for selected passport country, defaulting to United States
final passportCountryProvider =
    NotifierProvider<PassportCountryNotifier, Country>(
      PassportCountryNotifier.new,
    );

class PassportCountryNotifier extends Notifier<Country> {
  @override
  Country build() => Country(
    name: "United States",
    isoCode: "US",
    iso3Code: "USA",
    phoneCode: "",
  );

  void setCountry(Country countryName) {
    state = countryName;
  }
}

//Provider for selected destination country (initialized as empty string)
final destinationCountryProvider =
    NotifierProvider<DestinationCountryNotifier, Country?>(
      DestinationCountryNotifier.new,
    );

class DestinationCountryNotifier extends Notifier<Country?> {
  @override
  Country? build() => Country(
        isoCode: "",
        name: "",
        iso3Code: "",
        phoneCode: "",
      );

  void setCountry(Country? country) {
    if (country == null) {
      state = null;
    } else {
      state = Country(
        isoCode: country.isoCode,
        name: country.name,
        iso3Code: country.iso3Code,
        phoneCode: country.phoneCode,
      );
    }
  }
}

final showTravellerProvider = StateProvider<bool>((ref) => false);
