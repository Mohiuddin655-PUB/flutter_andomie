part of 'entities.dart';

class UserEntity extends Entity {
  final String email;
  final String name;
  final String password;
  final String phone;
  final String photo;
  final String provider;

  const UserEntity({
    super.id = "",
    this.email = "",
    this.name = "",
    this.password = "",
    this.phone = "",
    this.photo = "",
    this.provider = "",
  });

  UserEntity copy({
    String? id,
    String? email,
    String? name,
    String? password,
    String? phone,
    String? photo,
    String? provider,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      provider: provider ?? this.provider,
    );
  }

  factory UserEntity.from(dynamic data) {
    dynamic id, email, name, password, phone, photo, provider;
    if (data is Map) {
      try {
        id = data['id'];
        email = data['email'];
        name = data['name'];
        password = data['password'];
        phone = data['phone'];
        photo = data['photo'];
        provider = data['provider'];
        return UserEntity(
          id: id is String ? id : "",
          email: email is String ? email : "",
          name: name is String ? name : "",
          password: password is String ? password : "",
          phone: phone is String ? phone : "",
          photo: photo is String ? photo : "",
          provider: provider is String ? provider : "",
        );
      } catch (e) {
        log(e.toString());
      }
    }
    return const UserEntity();
  }

  bool get isCurrentUid => id == AuthHelper.uid;

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "photo": photo,
      "provider": provider,
    };
  }
}

enum AuthProvider {
  email,
  phone,
  facebook,
  google,
  twitter,
  apple,
}
