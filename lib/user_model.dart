class User {
  User({this.userId = '', this.nickname = '', this.imageUrl = ''});
  String userId;
  String nickname;
  String imageUrl;

  @override
  String toString() {
    return "User: {userId: $userId, nickName: $nickname, imageUrl: $imageUrl}";
  }
}
