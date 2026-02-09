class Pagination {
  int totalRecords;
  int currentPage;
  int totalPages;
  int limit;

  Pagination({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['totalRecords'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      limit: json['limit'],
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

  Pagination copyWith({
    int? totalRecords,
    int? currentPage,
    int? totalPages,
    int? limit,
  }) {
    return Pagination(
      totalRecords: totalRecords ?? this.totalRecords,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
    );
  }
}
