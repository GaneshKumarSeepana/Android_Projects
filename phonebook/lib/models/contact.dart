class Contact {
  int? id;
  String name;
  String number;

  Contact({this.id, required this.name, required this.number});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'number': number,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      number: map['number'],
    );
  }
}