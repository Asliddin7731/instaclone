class Post {
  String uid = '';
  String fullName = '';
  String imgUser = '';

  String id = '';
  String imgPost = '';
  String caption = '';
  String date = '';
  bool liked = false;

  bool mine = false;

  Post(this.caption, this.imgPost);

  Post.fromJson (Map<String, dynamic> json)
  :     uid = json ['uid'],
        fullName = json ['fullName'],
        imgUser = json ['imgUser'],

        id = json ['id'],
        imgPost = json ['imgPost'],
        caption = json ['caption'],
        date = json ['date'],
        liked = json ['liked'];

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'fullName' : fullName,
    'imgUser' : imgUser,

    'id' : id,
    'imgPost' : imgPost,
    'caption' : caption,
    'date' : date,
    'liked' : liked
  };
}