class BeritaPengumumanModel {
  final int id;
  final int? instansiId;
  final String jenis;
  final String judul;
  final String slug;
  final String? ringkasan;
  final String? konten;
  final String? gambar;
  final String? gambarUrl;
  final String status;
  final DateTime? publishedAt;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final InstansiBeritaModel? instansi;

  BeritaPengumumanModel({
    required this.id,
    this.instansiId,
    required this.jenis,
    required this.judul,
    required this.slug,
    this.ringkasan,
    this.konten,
    this.gambar,
    this.gambarUrl,
    required this.status,
    this.publishedAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.instansi,
  });

  factory BeritaPengumumanModel.fromJson(Map<String, dynamic> json) {
    return BeritaPengumumanModel(
      id: _toInt(json['id']) ?? 0,
      instansiId: _toInt(json['instansi_id']),
      jenis: json['jenis']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      ringkasan: json['ringkasan']?.toString(),
      konten: json['konten']?.toString(),
      gambar: json['gambar']?.toString(),
      gambarUrl: json['gambar_url']?.toString(),
      status: json['status']?.toString() ?? '',
      publishedAt: _toDateTime(json['published_at']),
      createdBy: _toInt(json['created_by']),
      updatedBy: _toInt(json['updated_by']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      deletedAt: _toDateTime(json['deleted_at']),
      instansi: json['instansi'] is Map<String, dynamic>
          ? InstansiBeritaModel.fromJson(
              json['instansi'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instansi_id': instansiId,
      'jenis': jenis,
      'judul': judul,
      'slug': slug,
      'ringkasan': ringkasan,
      'konten': konten,
      'gambar': gambar,
      'gambar_url': gambarUrl,
      'status': status,
      'published_at': publishedAt?.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'instansi': instansi?.toJson(),
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    return DateTime.tryParse(value.toString());
  }

  bool get isBerita => jenis == 'berita';

  bool get isPengumuman => jenis == 'pengumuman';

  bool get isPublished => status == 'published';
}

// =======================================================
// INSTANSI
// =======================================================

class InstansiBeritaModel {
  final int id;
  final String nama;

  InstansiBeritaModel({required this.id, required this.nama});

  factory InstansiBeritaModel.fromJson(Map<String, dynamic> json) {
    return InstansiBeritaModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nama: json['nama']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama};
  }
}

// =======================================================
// PAGINATION
// =======================================================

class BeritaPengumumanPagination {
  final int currentPage;
  final List<BeritaPengumumanModel> data;
  final int lastPage;
  final int perPage;
  final int total;
  final int? from;
  final int? to;
  final String? nextPageUrl;
  final String? prevPageUrl;

  BeritaPengumumanPagination({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.from,
    this.to,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory BeritaPengumumanPagination.fromJson(Map<String, dynamic> json) {
    final items = json['data'] as List? ?? [];

    return BeritaPengumumanPagination(
      currentPage: _toInt(json['current_page']) ?? 1,
      data: items
          .whereType<Map<String, dynamic>>()
          .map(BeritaPengumumanModel.fromJson)
          .toList(),
      lastPage: _toInt(json['last_page']) ?? 1,
      perPage: _toInt(json['per_page']) ?? 10,
      total: _toInt(json['total']) ?? 0,
      from: _toInt(json['from']),
      to: _toInt(json['to']),
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  bool get hasNextPage => nextPageUrl != null;

  bool get hasPreviousPage => prevPageUrl != null;
}

// =======================================================
// RESPONSE LIST
// =======================================================

class BeritaPengumumanListResponse {
  final bool status;
  final String message;
  final BeritaPengumumanPagination data;

  BeritaPengumumanListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BeritaPengumumanListResponse.fromJson(Map<String, dynamic> json) {
    return BeritaPengumumanListResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: BeritaPengumumanPagination.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
