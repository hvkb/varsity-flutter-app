class PostModel {
  final String postID;
  final String imageURL;
  final String username;
  final String caption;
  final String uid;
  final DateTime uploadDate;
  List<dynamic> likedBy;
  PostModel(
      {this.imageURL,
      this.uid,
      this.caption,
      this.username,
      this.uploadDate,
      this.likedBy,
      this.postID});
}
