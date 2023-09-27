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
}
