import 'tenant_model.dart';

class UserModel {
  final int idusuario;
  final String nombrecompleto;
  final String email;
  final bool activo;
  final String? fecharegistro;
  final TenantModel? tenant;
  final List<String> roles;

  UserModel({
    required this.idusuario,
    required this.nombrecompleto,
    required this.email,
    required this.activo,
    this.fecharegistro,
    this.tenant,
    List<String>? roles,
  }) : roles = roles ?? const <String>[];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String fullName = json['nombrecompleto'] ?? '';
    if (fullName.isEmpty && (json['first_name'] != null || json['last_name'] != null)) {
      fullName = '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim();
    }
    if (fullName.isEmpty) fullName = 'Administrador General';

    return UserModel(
      idusuario: json['idusuario'] is int
          ? json['idusuario']
          : int.tryParse(json['idusuario']?.toString() ?? '1') ?? 1,
      nombrecompleto: fullName,
      email: json['email'] ?? '',
      activo: json['activo'] ?? json['is_active'] ?? true,
      fecharegistro: json['fecharegistro'] ?? json['created_at'],
      tenant: json['tenant'] != null ? TenantModel.fromJson(json['tenant']) : null,
      roles: (json['roles'] is List)
          ? (json['roles'] as List).map((rol) => rol.toString()).toList()
          : const <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idusuario': idusuario,
      'nombrecompleto': nombrecompleto,
      'email': email,
      'activo': activo,
      'fecharegistro': fecharegistro,
      'tenant': tenant?.toJson(),
      'roles': roles,
    };
  }
}
