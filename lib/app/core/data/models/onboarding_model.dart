class OnboardingModel {
  final int id;
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}