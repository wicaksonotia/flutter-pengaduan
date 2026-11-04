class SharedProfileModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final List<SharedProfileRole> roles;

  const SharedProfileModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.roles = const [],
  });

  factory SharedProfileModel.fromResponse(Map<String, dynamic> response) {
    if (response['status'] == false || response['status'] == 'error') {
      throw Exception(
        response['message'] ?? 'Gagal mengambil profil pengguna.',
      );
    }

    final data = _asMap(response['data']);
    final user = _asMap(data['user']);

    if (user.isEmpty) {
      throw Exception('Data pengguna tidak ditemukan.');
    }

    final rawRoles = user['roles'];
    final roles = rawRoles is List
        ? rawRoles
              .whereType<Map>()
              .map(
                (item) =>
                    SharedProfileRole.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <SharedProfileRole>[];

    return SharedProfileModel(
      id: _toInt(user['id']),
      name: user['name']?.toString() ?? '-',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      avatar: user['avatar']?.toString(),
      roles: roles,
    );
  }

  SharedProfileRole? get primaryRole => roles.isNotEmpty ? roles.first : null;

  String get roleName => primaryRole?.nama.isNotEmpty == true
      ? primaryRole!.nama
      : 'Pengguna eLingk';

  String get unitName => primaryRole?.unitNama ?? '';

  String get roleDescription {
    if (unitName.isEmpty) return roleName;
    return '$roleName • $unitName';
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class SharedProfileRole {
  final int? id;
  final String nama;
  final String kode;
  final int? unitId;
  final String unitNama;
  final int? instansiId;
  final String instansiNama;

  const SharedProfileRole({
    this.id,
    required this.nama,
    required this.kode,
    this.unitId,
    required this.unitNama,
    this.instansiId,
    required this.instansiNama,
  });

  factory SharedProfileRole.fromJson(Map<String, dynamic> json) {
    return SharedProfileRole(
      id: _toInt(json['id']),
      nama: json['nama']?.toString() ?? '',
      kode: json['kode']?.toString() ?? '',
      unitId: _toInt(json['unit_id']),
      unitNama: json['unit_nama']?.toString() ?? '',
      instansiId: _toInt(json['instansi_id']),
      instansiNama: json['instansi_nama']?.toString() ?? '',
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
