class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final bool requiresLoginPassword;
  final bool isPasswordNotSet;
  final String? error;
  final String? infoMessage;
  final dynamic data;

  LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isPasswordNotSet = false,
    this.requiresLoginPassword = false,
    this.error,
    this.infoMessage,
    this.data,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isPasswordNotSet,
    bool? requiresLoginPassword,
    String? error,
    String? infoMessage,
    dynamic data,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordNotSet: isPasswordNotSet ?? this.isPasswordNotSet,
      requiresLoginPassword:
          requiresLoginPassword ?? this.requiresLoginPassword,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      infoMessage: infoMessage,
      data: data ?? this.data,
    );
  }
}
