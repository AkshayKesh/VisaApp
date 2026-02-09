import 'package:hive/hive.dart';

part 'visa_passing_model.g.dart';

@HiveType(typeId: 1)
class VisaApplicationModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? visaType;

  @HiveField(2)
  final int? lengthOfStay;

  @HiveField(3)
  final int? visaValidity;

  @HiveField(4)
  final String? country;

  @HiveField(6)
  final int? visaFee;

  @HiveField(7)
  final String? entryType;

  VisaApplicationModel({
    this.id,
    this.visaType,
    this.lengthOfStay,
    this.visaValidity,
    this.country,
    this.entryType,
    this.visaFee = 0,
  });

  /// copyWith for updates
  VisaApplicationModel copyWith({
    String? id,
    String? visaType,
    int? lengthOfStay,
    int? visaValidity,
    int? visaFee,
    String? country,
    String? entryType,
  }) {
    return VisaApplicationModel(
      id: id ?? this.id,
      visaType: visaType ?? this.visaType,
      lengthOfStay: lengthOfStay ?? this.lengthOfStay,
      visaFee: visaFee ?? this.visaFee,
      visaValidity: visaValidity ?? this.visaValidity,
      country: country ?? this.country,
      entryType: entryType ?? this.entryType,
    );
  }
}
