part of 'info_cubit.dart';

class InfoState extends Equatable {
  const InfoState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.adminInfo,
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;
  final AdminInfo? adminInfo;

  @override
  List<Object?> get props => [status, errorMessage ?? '', adminInfo];

  InfoState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage,
    AdminInfo? adminInfo,
  }) {
    return InfoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      adminInfo: adminInfo ?? this.adminInfo,
    );
  }
}
