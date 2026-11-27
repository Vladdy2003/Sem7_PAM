import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_details.dart';
import '../../../domain/entities/doctor.dart';
import '../../../domain/usecases/get_appointment_details.dart';

// Starile ecranului de programare: Loading -> Loaded / Error
sealed class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();

  @override
  List<Object?> get props => [];
}

final class AppointmentDetailsLoading extends AppointmentDetailsState {
  const AppointmentDetailsLoading();
}

final class AppointmentDetailsLoaded extends AppointmentDetailsState {
  final AppointmentDetails details;
  const AppointmentDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

final class AppointmentDetailsError extends AppointmentDetailsState {
  final String message;
  const AppointmentDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Presentation: incarca detaliile programarii prin use case-ul
// GetAppointmentDetails (Domain) -> repository -> GET /feed/details.
// Daca ecranul a fost deschis dintr-un doctor din lista "Nearby",
// sablonul primit de la server este personalizat pentru acel doctor.
class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final GetAppointmentDetails _getAppointmentDetails;
  final Doctor? doctor;

  AppointmentDetailsCubit(this._getAppointmentDetails, {this.doctor})
      : super(const AppointmentDetailsLoading());

  Future<void> load() async {
    emit(const AppointmentDetailsLoading());
    final result = await _getAppointmentDetails();
    if (isClosed) return;
    result.fold(
      onSuccess: (details) => emit(AppointmentDetailsLoaded(_personalize(details))),
      onFailure: (failure) => emit(AppointmentDetailsError(
          'Could not load appointment details.\n${failure.message}')),
    );
  }

  AppointmentDetails _personalize(AppointmentDetails details) {
    final d = doctor;
    if (d == null) return details;
    return details.forDoctor(details.doctor.copyWith(
      name: d.name,
      clinic: d.specialty,
      avatarUrl: d.avatarUrl,
    ));
  }
}
