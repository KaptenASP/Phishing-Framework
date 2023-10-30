enum PersonStatus { inactive, active }

class Victim {
  String email;
  String name;
  String password = "";

  PersonStatus status = PersonStatus.inactive;

  Victim(this.email, this.name);

  Victim.withPassword(this.email, this.password, this.name);

  void setPassword(String password) {
    this.password = password;
  }

  void setStatus(PersonStatus status) {
    this.status = status;
  }

  static Victim fromJson(Map<String, dynamic> json) => Victim.withPassword(
        json['email'] as String,
        json['password'] as String,
        json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
      };
}
