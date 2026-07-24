// ignore_for_file: constant_identifier_names

enum LanguageCode { en, ar }

enum Themes { light, dark }

enum UserCycle {
  firstOpen, // WelcomeScreen / Onboarding
  login, // Not logged in (saw onboarding)
  auth, // Logged in
  guest, // Continue as guest
}

enum UserType {
  pending, // FlowScreen
  refused, // FlowScreen
  approved,
  user,
  provider,
  delegate,
}
