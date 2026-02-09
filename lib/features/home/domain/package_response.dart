// Model for PackageResponse
class PackageResponse {
  final int statusCode;
  final String message;
  final List<CountryPackage> data;
  final Pagination pagination;

  const PackageResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory PackageResponse.fromJson(Map<String, dynamic> json) {
    return PackageResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CountryPackage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class CountryPackage {
  final String id;
  final String country;
  final String coverPhoto;
  final String title;
  final String subtitle;

  final String status;

  const CountryPackage({
    required this.id,
    required this.country,
    required this.coverPhoto,
    required this.title,
    required this.subtitle,

    required this.status,
  });

  factory CountryPackage.fromJson(Map<String, dynamic> json) {
    return CountryPackage(
      id: json['_id'] ?? '',
      country: json['country'] ?? '',
      coverPhoto: json['coverPhoto'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',

      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'country': country,
      'coverPhoto': coverPhoto,
      'title': title,
      'subtitle': subtitle,

      'status': status,
    };
  }
}

class Pagination {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int limit;

  const Pagination({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['totalRecords'] is int
          ? json['totalRecords']
          : int.tryParse(json['totalRecords'].toString()) ?? 0,
      currentPage: json['currentPage'] is int
          ? json['currentPage']
          : int.tryParse(json['currentPage'].toString()) ?? 0,
      totalPages: json['totalPages'] is int
          ? json['totalPages']
          : int.tryParse(json['totalPages'].toString()) ?? 0,
      limit: json['limit'] is int
          ? json['limit']
          : int.tryParse(json['limit'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'limit': limit,
    };
  }
}
