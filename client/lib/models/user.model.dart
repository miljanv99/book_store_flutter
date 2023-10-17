class User {
 String id;
 String name;
 String email;

 User({required this.id, required this.name, required this.email});

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
 }

 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
 }
}