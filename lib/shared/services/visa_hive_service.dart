import 'package:hive/hive.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_passing_model.dart';

class VisaHiveService {
  VisaHiveService._internal();
  static final VisaHiveService instance = VisaHiveService._internal();

  static const String _boxName = 'visaApplications';

  Box<VisaApplicationModel> get _box =>
      Hive.box<VisaApplicationModel>(_boxName);

  // =======================
  // CREATE / SAVE
  // =======================

  Future<void> saveVisa(VisaApplicationModel visa) async {
    await _box.put("visaApplications", visa);
  }
  // =======================
  // GETTERS (Single)
  // =======================

  String? getVisaById() {
    final applicationBox = _box.get("visaApplications");

    return applicationBox?.id;
  }

  String? getVisaType() {
    final applicationBox = _box.get("visaApplications");
    return applicationBox?.visaType;
  }

  int? getLengthOfStay() {
    final applicationBox = _box.get("visaApplications");
    return applicationBox?.lengthOfStay;
  }

  int? getVisaValidity() {
    final applicationBox = _box.get("visaApplications");
    return applicationBox?.visaValidity;
  }

  Future<void> updateId(String value) async {
    final visa = _box.get("visaApplications");
    if (visa == null) return;

    await _box.put("visaApplications", visa.copyWith(id: value));
  }

  int? getVisaFee() {
    final applicationBox = _box.get("visaApplications");
    return applicationBox?.visaFee;
  }

  String? getEntryType() {
    final applicationBox = _box.get("visaApplications");
    return applicationBox?.entryType;
  }

  String? getCountry() {
    final applicationBox = _box.get("visaApplications");
    return applicationBox?.country;
  }

  // =======================
  // SETTERS (Single Field)
  // =======================

  Future<void> updateVisaType(String value) async {
    final visa = _box.get("visaApplications");
    if (visa == null) return;

    await _box.put("visaApplications", visa.copyWith(visaType: value));
  }

  Future<void> updateLengthOfStay(int value) async {
    final visa = _box.get("visaApplications");
    if (visa == null) return;

    await _box.put("visaApplications", visa.copyWith(lengthOfStay: value));
  }

  Future<void> updateVisaValidity(int value) async {
    final visa = _box.get("visaApplications");
    if (visa == null) return;

    await _box.put("visaApplications", visa.copyWith(visaValidity: value));
  }

  Future<void> updateCountry(String value) async {
    final visa = _box.get("visaApplications");
    if (visa == null) return;

    await _box.put("visaApplications", visa.copyWith(country: value));
  }

  Future<void> updateVisaApplication(
    String? visaType,
    int? lengthOfStay,
    int? visaValidity,
    String? country,
    String? entryType,
    int? visaFee,
  ) async {
    final visa = _box.get("visaApplications");

    if (visa == null) return;

    await _box.put(
      "visaApplications",
      visa.copyWith(
        country: country,
        entryType: entryType,
        lengthOfStay: lengthOfStay,
        visaType: visaType,
        visaValidity: visaValidity,
        visaFee: visaFee,
      ),
    );
  }

  // =======================
  // DELETE
  // =======================

  Future<void> deleteVisa(String id) async {
    await _box.delete(id);
  }

  // =======================
  // CLEAR ALL
  // =======================

  Future<void> clearAll() async {
    await _box.clear();
  }

  Map<String, dynamic> getVisaMdoel() {
    final visa = _box.get("visaApplications");
    return {
      "id": visa?.id ?? 0,
      "country": visa?.country ?? "",
      "lengthOfStay": visa?.lengthOfStay ?? 0,
      "visaType": visa?.visaType ?? 0,
      "visaValidity": visa?.visaValidity ?? 0,
    };
  }
}
