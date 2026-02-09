import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/features/profile/domain/card_model.dart';
import 'package:register_visa_web_app/features/profile/providers/states/card_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';

class CardController extends AsyncNotifier<CardState> {
  @override
  FutureOr<CardState> build() {
    return loadCards();
  }

  String? _cardUrl;

  String? get cardUrl => _cardUrl;

  set cardUrl(String? value) {
    print("CURL URL SET$value");
    _cardUrl = value;
    // Optionally notify listeners if needed, e.g., state = state.copyWith(...)
  }

  // Example: Load cards from a source
  Future<CardState> loadCards() async {
    state = const AsyncLoading();
    try {
      // Simulate API/DB fetch

      ResponseAPI response = await ApiManager.get(
        methodName: ApiEndpoints.getAllCard,
      );

      if (response.data["statusCode"] == 200) {
        List<PaymentCardModel> cardList = [];

        if (response.data["data"] is List) {
          cardList = (response.data["data"] as List)
              .map(
                (e) => PaymentCardModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();
        }

        return CardState(cards: cardList, isLoading: false, isSuccess: true);
      } else {
        return CardState(cards: [], isLoading: false, isSuccess: false);
      }
    } catch (e) {
      return CardState(isLoading: false, isSuccess: false, error: e.toString());
    }
  }

  Future<String?> getCardUrl() async {
    try {
      ResponseAPI response = await ApiManager.get(
        methodName: ApiEndpoints.getCardLink,
      );
      if (response.data["statusCode"] == 200) {
        return response.data["data"];
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  void updateCards(List<PaymentCardModel> newCards) {
    // Update the list of cards in the CardState and notify listeners
    state = AsyncData(CardState(
      cards: newCards,
      isLoading: false,
      isSuccess: true,
      error: null,
    ));
  }
}
