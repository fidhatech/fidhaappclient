class EmployeeConstants {
  static const String featureName = 'EMPLOYEE';

  // API Endpoints
  static const String endpointHome = 'employee/home';
  static const String endpointProfile = 'employee/profile';
  static const String endpointProfileUpdate = 'employee/profile/update';
  static const String endpointProfileDelete = 'employee/profile/delete';
  static const String endpointCallPreference =
      'employee/profile/call-preference';
  static const String endpointLogout = '/employee/auth/logout';
  static const String endpointRefresh = 'employee/auth/refresh';

  // Withdrawal Endpoints
  static const String endpointWithdrawalRequest =
      '/employee/withdrawal/request';
  static const String endpointWithdrawalHistory =
      '/employee/withdrawal/history';

  // Socket Events
  static const String eventAcceptCall = 'accept_call';
  static const String eventRejectCall = 'reject_call';
  static const String eventEndCall = 'end_call';
  static const String eventIncomingCall = 'incoming_call';

  // Messages
  static const String msgFetchHomeError = 'Failed to fetch employee home data';
  static const String msgUpdatePrefError = 'Failed to update call preference';
  static const String msgFetchProfileError = 'Failed to fetch employee profile';
  static const String msgUpdateProfileError = 'Failed to update profile';
  static const String msgLogoutError = 'Failed to logout';
  static const String msgDeleteError = 'Failed to delete account';
  static const String msgConnectionFailed = 'Connection Failed';

  // UI Strings
  static const String uiNoInternet = 'No Internet Connection';
  static const String uiRetry = 'Retry Connection';
  static const String uiTryAgain = 'Try Again';
}
