enum PersonStatus { inactive, active }

class Victim {
  String email;
  String password = "";

  PersonStatus status = PersonStatus.inactive;

  Victim(this.email);

  Victim.withPassword(this.email, this.password);

  void setPassword(String password) {
    this.password = password;
  }

  void setStatus(PersonStatus status) {
    this.status = status;
  }

  static Victim fromJson(Map<String, dynamic> json) => Victim.withPassword(
        json['email'] as String,
        json['password'] as String,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
