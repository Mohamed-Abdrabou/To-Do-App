class User{
  String? phoneNumber;
  int? age;
  String? id;
  String? email;
  String? name;
  static const String collection = "User";
  User({this.name,this.id,this.email,this.age,this.phoneNumber});


  User.fromFirestore(Map<String,dynamic>? data)
  {
    id = data?["id"];
    phoneNumber = data?["phone"];
    email = data?["email"];
    age = data?["age"];
    name = data?["FullName"];
  }


  Map<String,dynamic> toFirestore()
  {
    return{
      "FullName":name,
      "id":id,
      "age":age,
      "phone":phoneNumber,
      "email":email
    };
  }

}