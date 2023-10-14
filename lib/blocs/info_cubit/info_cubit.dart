import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/helpers/exception_helper.dart';
import 'package:utc_gas_station/models/admin_info.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit({
    required this.apiService,
  }) : super(const InfoState());

  final ApiService apiService;

  Future<void> getInfo() async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
    ));
    final failureOrResponse = await apiService.getInfo();
    failureOrResponse.fold(
      (l)  => emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: getErrorMessage(l),
        )),
      (r) => emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          adminInfo: r,
        )),
    );
  }
}
