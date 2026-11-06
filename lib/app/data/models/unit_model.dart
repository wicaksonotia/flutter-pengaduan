class UnitModel {
  final int id;
  final int instansiId;
  final int? parentId;
  final String kode;
  final String nama;
  final String? deskripsi;
  final String? alamat;
  final String? telepon;
  final bool aktif;
  final InstansiOption? instansi;
  final UnitParentOption? parent;
  final List<UnitParentOption> children;

  const UnitModel({
    required this.id,
    required this.instansiId,
    this.parentId,
    required this.kode,
    required this.nama,
    this.deskripsi,
    this.alamat,
    this.telepon,
    this.aktif = true,
    this.instansi,
    this.parent,
    this.children = const [],
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: _toInt(json['id']),
      instansiId: _toInt(json['instansi_id']),
      parentId: json['parent_id'] == null ? null : _toInt(json['parent_id']),
      kode: '${json['kode'] ?? ''}',
      nama: '${json['nama'] ?? ''}',
      deskripsi: json['deskripsi']?.toString(),
      alamat: json['alamat']?.toString(),
      telepon: json['telepon']?.toString(),
      aktif: _toBool(json['aktif']),
      instansi: json['instansi'] is Map
          ? InstansiOption.fromJson(Map<String, dynamic>.from(json['instansi']))
          : null,
      parent: json['parent'] is Map
          ? UnitParentOption.fromJson(Map<String, dynamic>.from(json['parent']))
          : null,
      children: json['children'] is List
          ? (json['children'] as List)
                .whereType<Map>()
                .map(
                  (e) =>
                      UnitParentOption.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    return value == 1 || value == '1' || value == 'true';
  }
}

class InstansiOption {
  final int id;
  final String nama;
  final String? singkatan;

  const InstansiOption({required this.id, required this.nama, this.singkatan});

  factory InstansiOption.fromJson(Map<String, dynamic> json) {
    return InstansiOption(
      id: int.tryParse('${json['id']}') ?? 0,
      nama: '${json['nama'] ?? ''}',
      singkatan: json['singkatan']?.toString(),
    );
  }
}

class UnitParentOption {
  final int id;
  final String nama;
  final String? kode;

  const UnitParentOption({required this.id, required this.nama, this.kode});

  factory UnitParentOption.fromJson(Map<String, dynamic> json) {
    return UnitParentOption(
      id: int.tryParse('${json['id']}') ?? 0,
      nama: '${json['nama'] ?? ''}',
      kode: json['kode']?.toString(),
    );
  }
}
