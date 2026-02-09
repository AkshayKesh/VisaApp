enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? message;

  ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.message,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? message,
  }) {
    return ChangePasswordState(status: status ?? this.status, message: message);
  }
}
