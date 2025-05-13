class History{
  String vehicleName;
  String country;

  History({required this.vehicleName, required this.country}); 

  factory History.fromJson(Map<String, dynamic> json) => History(
        vehicleName: json["vhicleName"],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "vhicleName": vehicleName,
        "country": country,
    };

}