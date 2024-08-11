class SavedResponseModel {
  // Define class properties
  int? id; // User ID
  String? title; // User name
  String? response; // User email
  String? path;
  // Constructor with optional 'id' parameter
  SavedResponseModel(this.title, this.response, this.path, {this.id});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  SavedResponseModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    response = map['response'];
    path = map['img_path'];
  }

// Method to convert a 'SavedResponseModel' to a map
  Map<String, dynamic> toJson() {
    return {'title': title, 'response': response, 'img_path': path};
  }
}
