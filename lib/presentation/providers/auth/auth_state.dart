class AuthState {
  final bool isAuthenticated;
  final String? userEmail;
  final String? username;
  final bool isLoading;

  AuthState({
    required this.isAuthenticated,
    this.userEmail,
    this.username,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userEmail,
    String? username,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}