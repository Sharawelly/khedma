class OrderParams {
  final int? id;
  final int? providerId;
  final String? address;
  final String? lat;
  final String? lng;
  final String? name;
  final List? carts;
  final String? phone;
  final DateTime? date;
  final String? time;
  final String? notes;
  final int? serviceTypeId;
  final String? payment;
  final String? status;

  OrderParams({
    this.id,
    this.providerId,
    this.address,
    this.lat,
    this.lng,
    this.name,
    this.carts,
    this.phone,
    this.date,
    this.time,
    this.notes,
    this.serviceTypeId,
    this.payment,
    this.status,
  });

  OrderParams copyWith({
    int? id,
    int? providerId,
    String? address,
    String? lat,
    String? lng,
    String? name,
    List? carts,
    String? phone,
    DateTime? date,
    String? time,
    String? notes,
    int? serviceTypeId,
    String? payment,
    String? status,
  }) {
    return OrderParams(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      name: name ?? this.name,
      carts: carts ?? this.carts,
      phone: phone ?? this.phone,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      payment: payment ?? this.payment,
      status: status ?? this.status,
    );
  }

  factory OrderParams.fromJson(Map<String, dynamic> json) => OrderParams(
        id: json["id"],
        providerId: json["provider_id"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        name: json["name"],
        carts: json["carts"] == null
            ? []
            : List<Cart>.from(json["carts"]!.map((x) => Cart.fromJson(x))),
        phone: json["phone"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        notes: json["notes"],
        serviceTypeId: json["service_type_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "address": address,
        "lat": lat,
        "lng": lng,
        "name": name,
        "carts": carts == null
            ? []
            : List<dynamic>.from(carts!.map((x) => x.toJson())),
        "phone": phone,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "notes": notes,
        "service_type_id": serviceTypeId,
      };
  Map<String, dynamic> toLaundryOrderJson() => {
        "status": status,
      };
}

class Cart {
  final int? serviceId;
  final int? subcategoryId;
  final double? price;
  final int? quantity;

  Cart({
    this.serviceId,
    this.subcategoryId,
    this.price,
    this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        serviceId: json["service_id"],
        subcategoryId: json["subcategory_id"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "subcategory_id": subcategoryId,
        "price": price,
        "quantity": quantity,
      };
}
