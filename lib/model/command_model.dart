class CommandModel {
  // Define class properties
  int? id; // User ID
  String? title; // User name
  String? command; // User email
  int? status; // User email

  // Constructor with optional 'id' parameter
  CommandModel(this.title, this.command, this.status, {this.id});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  CommandModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    command = map['command'];
    status = map['status'];
  }

// Method to convert a 'CommandModel' to a map
  Map<String, dynamic> toJson() {
    return {'title': title, 'command': command, 'status': status};
  }
}
