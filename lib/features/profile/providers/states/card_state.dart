import 'package:register_visa_web_app/features/profile/domain/card_model.dart';

class CardState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<PaymentCardModel> cards;

  CardState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.cards = const [],
  });

  CardState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<PaymentCardModel>? cards,
  }) {
    return CardState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      cards: cards ?? this.cards,
    );
  }

  factory CardState.fromJson(Map<String, dynamic> json) {
    return CardState(
      isLoading: json['isLoading'] ?? false,
      isSuccess: json['isSuccess'] ?? false,
      error: json['error'],
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => PaymentCardModel.fromJson(e))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoading': isLoading,
      'isSuccess': isSuccess,
      'error': error,
      'cards': cards.map((e) => e.toJson()).toList(),
    };
  }
}
