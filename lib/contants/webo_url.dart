class WebOURL {
  static const base = 'http://123.57.50.102:8080';

  // Auth
  static const login = base + '/user/login';
  static const register = base + '/user/register';
  static const refresh = base + '/user/refresh';

  // Posts
  static const allPosts = base + '/post/all';
  static const postDetail = base + '/post';
  static const createPost = base + '/post/new';
  static const likePost = base + '/post/like';
  static const forwardPost = base + '/post/forward';
  static const myPosts = base + '/post/mine';
  static const followingPosts = base + '/post/following';
  static const postDelete = base + '/post';
  static const getComment = base + '/comment/all';
  static const newComment = base + '/comment/new';

  // User
  static const user = base + '/user';
  static const userUpdate = base + '/user/modify';
  static const userChangePassword = base + '/user/change-password';
  static const follow = base + '/user/follow';
  static const followings = base + '/user/follow/all';
  static const followers = base + '/user/follow/all-by';
}
