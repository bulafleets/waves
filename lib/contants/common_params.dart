String AccountType = '';

String name = "";
String email = "";
String phoneno = "";
String user_id = "";
String gender = "";
String dob = "";
String profileimg = "";
String password = "";
String authorization = "";
String isSignUp = "";
String isBiometric = 'false';
String address = '';
var longitude;
var latitude;
var isReqData = [];

final String BASE = "http://34.229.12.96/api/";
final String URL_Login = BASE + "user/login";
final String URL_OTP = BASE + "send-otp";
final String URL_Signup = BASE + "signup";
final String Reset_passwordOtp = BASE + "resetPassword/mobile";
final String Reset_password = BASE + "user/resetPassword";
final String Get_all_users = BASE + 'get-all-users';
final String find_nearBy_friends = BASE + "get-users-by-location";
final String send_friend_request = BASE + "send-friend-request";
