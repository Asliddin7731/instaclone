class Post {
  String? imgPost;
  String? caption;

  Post(this.imgPost, this.caption);

  Post.fromJson (Map<String, dynamic> json)
  :     imgPost = json ['imgPost'],
        caption = json ['caption'];

  Map<String, dynamic> toJson() => {
    'imgPost' : imgPost,
    'caption' : caption
  };
}