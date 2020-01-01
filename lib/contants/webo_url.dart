class WebOURL {
  static const base = 'http://123.57.50.102:8080';

  // Auth
  static final String login = base + '/user/login';
  static final String register = base + '/user/register';
  static final String refresh = base + '/user/refresh';

  // Posts
  static final String allPosts = base + '/post/all';
  static final String postDetail = base + '/post';
  static final String createPost = base + '/post/new';
  static final String likePost = base + '/post/like';
  static final String forwardPost = base + '/post/forward';
  static final String myPosts = base + '/post/mine';
  static final String followingPosts = base + '/post/following';
  static const postDelete = base + '/post';
  static const getComment = base + '/comment/all';
  static const newComment = base + 'comment/new';

  // User
  static final String user = base + '/user';
  static final String userUpdate = base + '/user/modify';
  static final String userChangePassword = base + '/user/change-password';
  static final String follow = base + '/user/follow';
  static final String followings = base + '/user/follow/all';
  static final String followers = base + '/user/follow/all-by';
}
