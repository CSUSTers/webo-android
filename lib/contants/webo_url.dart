class WebOURL {
  static final String base = 'http://123.57.50.102:8080';

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


  // User
  static final String user = base + '/user';
  static final String follow = base + '/follow';
  static final String followings = base + '/follow/all';
  static final String followers = base + '/follow/all-by';
}