class VisaApplication {
  final String travelerName;
  final String appliedDate; // ISO or formatted string
  final String country;
  final String status;

  VisaApplication({required this.travelerName, required this.appliedDate, required this.country, required this.status});
  Map<String, dynamic> toJson() {
    return {
      'travelerName': travelerName,
      'appliedDate': appliedDate,
      'country': country,
      'status': status,
    };
  }
}
