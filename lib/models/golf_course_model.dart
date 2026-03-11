class GolfCourseModel {
  final int id;
  final String name;
  final String? coverImage;
  final int likesCount;
  final bool isLiked;
  final bool isActive;

  GolfCourseModel({
    required this.id,
    required this.name,
    this.coverImage,
    this.likesCount = 0,
    this.isLiked = false,
    this.isActive = true,
  });

  factory GolfCourseModel.fromJson(Map<String, dynamic> json) {
    return GolfCourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      coverImage: json['cover_image'] as String?,
      likesCount: json['likes_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      isActive: (json['is_active'] as int? ?? 1) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cover_image': coverImage,
      'likes_count': likesCount,
      'is_liked': isLiked,
      'is_active': isActive ? 1 : 0,
    };
  }
}