import 'package:waves/models/notification_model.dart';

String AccountType = '';

String name = "";
String email = "";
String mobile = "";
String user_id = "";
String gender = "";
String age = "";
var dateOfBirth;
String bio = '';
String profileimg = "";
String password = "";
String authorization = "";
String isSignUp = "";
String isBiometric = 'false';
String address = '';
var longitude;
var latitude;
var isReqData = [];
String aboutdata = '';
String termContiondata = '';
String privacyPolicyData = '';
List<NotificationLocalModel> notificationData = [];
var isNotification = false;
int totalFollowing = 0;
var averageReviews;

final String BASE = "http://wavesbackend.plenumnetworks.com/api/";
final String URL_Login = BASE + "user/login";
final String URL_OTP = BASE + "send-otp";
final String URL_Signup = BASE + "signup";
final String Reset_passwordOtp = BASE + "resetPassword/mobile";
final String Reset_password = BASE + "user/resetPassword";
final String Change_password = BASE + 'changepassword';
final String Get_all_users = BASE + 'get-all-users';
final String find_nearBy_friends = BASE + "get-users-by-location";
final String send_friend_request = BASE + "send-friend-request";
final String MyAllFriends = BASE + 'my-all-friends';
final String MyFriendREquests = BASE + 'my-all-friends-requests';
final String AceeptFriendsRequest = BASE + 'accept-friend-request';
final String RemoveFriend = BASE + 'remove-friend';
final String MobileList = BASE + 'register/mobileList';
final String MobileInvitedList = BASE + 'request/mobileList';
final String MobileInvitePost = BASE + 'request/mobile';
final String WaveCreate = BASE + 'waves/create';
final String EventList = BASE + 'get/event-list';
final String waveListing = BASE + 'home/waves/lists';
final String SingleWaveView = BASE + 'wave/view';
final String MyWaveListing = BASE + "list/my-wave";
final String checkIn = BASE + 'wave/check-in';
final String UpdateProfile = BASE + 'user/updateprofile';
final String CheckInListingApi = BASE + 'wave/check-in/list';
final String AboutData = BASE + 'get-html-pages/slug';
final String MyActivity = BASE + 'user/my-activity';
final String LikeComment = BASE + 'comment/likes';
final String ReplyComment = BASE + 'wave/comment/reply';
final String Comment = BASE + 'wave/comment';
final String MapListing = BASE + 'wave-list/by-location';
final String ReviewBussines = BASE + 'create/wave/review';
final String ViewProfile = BASE + 'user/getprofile';
final String Follow = BASE + 'follow';
final String UnFollow = BASE + 'unfollow';
final String MyFollows = BASE + "myfollowers";
final String GetReviews = BASE + "get/review";
final String GetAverageReview = BASE + 'get/user/review';
