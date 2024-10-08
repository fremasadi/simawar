import 'package:cloud_firestore/cloud_firestore.dart';

class Pesanan {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String quantity;
  final Map<String, dynamic> sizes;
  final String status;
  final String type;
  final String deadline;
  final String imgUrl;

  Pesanan({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.quantity,
    required this.sizes,
    required this.status,
    required this.type,
    required this.deadline,
    required this.imgUrl
  });

  factory Pesanan.fromDocumentSnapshot(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Pesanan(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      quantity: data['quantity'] ?? '',
      sizes: data['sizes'] ?? {},
      status: data['status'] ?? '',
      type: data['type'] ?? '',
      deadline: data['deadline'] ?? '',
      imgUrl: data['imgUrl'] ?? ''
    );
  }

  // Definisikan toMap() di sini
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'quantity': quantity,
      'sizes': sizes,
      'status': status,
      'type': type,
      'deadline': deadline,
      'imgUrl' : imgUrl
    };
  }
}
