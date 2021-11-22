import 'dart:convert';

class Food {
  final int id;
  final String name;
  final String type;
  int qty;
  final double price;
  final String pic;
  Food({
    required this.id,
    required this.name,
    required this.type,
    required this.qty,
    required this.price,
    required this.pic,
  });

  Food copyWith({
    int? id,
    String? name,
    String? type,
    int? qty,
    double? price,
    String? pic,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      pic: pic ?? this.pic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'qty': qty,
      'price': price,
      'pic': pic,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id']?.toInt(),
      name: map['name'],
      type: map['type'],
      qty: map['qty']?.toInt(),
      price: map['price']?.toDouble(),
      pic: map['pic'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Food.fromJson(String source) => Food.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Food(id: $id, name: $name, type: $type, qty: $qty, price: $price, pic: $pic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Food &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.qty == qty &&
        other.price == price &&
        other.pic == pic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        qty.hashCode ^
        price.hashCode ^
        pic.hashCode;
  }
}
