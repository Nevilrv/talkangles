class AppUrls {
  static const BASE_URL = "https://talkangels-api.onrender.com/api/v1/";
}

class MethodNamesAngels {
  static const logIn = "auth/login";
  static const getAngle = "user/all-angels";
  static const getSingleAngleDetails = "user/angel-detail/";
  static const callAngle = "user/call";
  static const angleWallet = "user/add-ballence";
  static const getUserDetails = "user/detail/";
  static const getRechargeList = "user/all-recharge";
  static const postReferralCode = "user/apply-refer-code";
  static const postRating = "user/add-rating";
  static const postReportAProblem = "user/add-report";
  static const deleteAngel = "user/delete/";
}

class MethodNamesStaff {
  static const getStaffDetails = "staff/detail/";
  static const getStaffCallHistory = "staff/call-history/";
  static const sendWithdrawRequest = "staff/send-withdraw-request";
  static const activeStatus = "staff/update-active-status/";
  static const addCallHistory = "staff/save-call-history";
  static const postReportProblemStaff = "staff/add-report";
  static const updateCallStatus = "user/update-call-status/";
  static const updateStaffDetails = "staff/update-staff/";
  static const updateAngelAvailableStatus = "staff/update-available-status/";
}

class CommonApis {
  static const rejectCall = "call-reject";
  static const logOut = "auth/log-out";
}
