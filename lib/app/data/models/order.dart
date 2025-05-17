class Order {
  final int id;
  final String name;
  final String address;
  final String deadline;
  final String phone;
  final List<String> images;
  final String quantity;
  final String sizeModel;
  final Map<String, dynamic> size;
  final String status;
  final dynamic assignedTo;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.id,
    required this.name,
    required this.address,
    required this.deadline,
    required this.phone,
    required this.images,
    required this.quantity,
    required this.sizeModel,
    required this.size,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      deadline: json['deadline'] as String,
      phone: json['phone'] as String,
      images: List<String>.from(json['images']),
      quantity: json['quantity'] as String,
      // Changed from int to String
      sizeModel: json['size_model'] as String,
      size: Map<String, dynamic>.from(json['size']),
      status: json['status'] as String,
      assignedTo: json['ditugaskan_ke'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'deadline': deadline,
      'phone': phone,
      'images': images,
      'quantity': quantity,
      'size_model': sizeModel,
      'size': size,
      'status': status,
      'ditugaskan_ke': assignedTo,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
