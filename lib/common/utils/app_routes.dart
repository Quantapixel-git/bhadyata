class AppRoutes {
  static const splash = '/splash';
  static const home = '/onboarding';

  // static pages
  static const privacy = '/privacypolicy';
  static const terms = '/terms';
  static const contact = '/contact';
  static const refund = '/refund';
  static const blogs = '/blogs';

  // auth pages
  static const userLogin = '/login';
  static const userOtp = '/user/otp';
  static const employerLogin = '/employer/login';
  static const employerOtp = '/employer/otp';
  static const hrLogin = '/hr/login';
  static const hrOtp = '/hr/otp';
  static const adminLogin = '/admin/login';

  // dashboards
  static const userDashboard = '/user';
  static const employerDashboard = '/employer';
  static const hrDashboard = '/hr';
  static const adminDashboard = '/admin';

  // employer flow
  static const employerCompleteProfile = '/employer/complete-profile';
  static const employerTellUsMore = '/employer/tell-us-more';
  static const employerKycChecker = '/employer/kyc-checker';

  // user flow
  static const userCompleteProfile = '/user/complete-profile';
  static const userTellUsMore = '/user/tell-us-more';
  static const userKycChecker = '/user/kyc-checker';

  // ✅ HR flow
  static const hrCompleteProfile = '/hr/complete-profile';
  static const hrTellUsMore = '/hr/tell-us-more';
  static const hrKycChecker = '/hr/kyc-checker'; // 👈 NEW
}
