abstract class UserEvent {}

class UserLoginWithGoogleEvent extends UserEvent {}

class UserLoginWithFacebookEvent extends UserEvent {}

class UserLogoutEvent extends UserEvent {}
