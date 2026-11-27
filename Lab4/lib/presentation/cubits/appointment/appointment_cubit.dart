import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_details.dart';

enum BookingStatus { idle, booking, success, failure }

class AppointmentState extends Equatable {
  final String? selectedHourId;
  final String? selectedDateId;
  final BookingStatus status;
  final String? message;

  const AppointmentState({
    this.selectedHourId,
    this.selectedDateId,
    this.status = BookingStatus.idle,
    this.message,
  });

  AppointmentState copyWith({
    String? selectedHourId,
    String? selectedDateId,
    BookingStatus? status,
    String? message,
  }) =>
      AppointmentState(
        selectedHourId: selectedHourId ?? this.selectedHourId,
        selectedDateId: selectedDateId ?? this.selectedDateId,
        status: status ?? this.status,
        message: message,
      );

  @override
  List<Object?> get props => [selectedHourId, selectedDateId, status, message];
}

// Starea ecranului de detalii: ora/ziua selectata si rezervarea (asincrona)
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentDetails details;
  final Duration bookingDelay;

  AppointmentCubit(
    this.details, {
    this.bookingDelay = const Duration(milliseconds: 1500),
  }) : super(AppointmentState(
          selectedHourId: details.workingHours.initialSelectedId,
          selectedDateId: details.dates.initialSelectedId,
        ));

  void selectHour(String id) =>
      emit(state.copyWith(selectedHourId: id, status: BookingStatus.idle));

  void selectDate(String id) =>
      emit(state.copyWith(selectedDateId: id, status: BookingStatus.idle));

  Future<void> book() async {
    if (state.status == BookingStatus.booking) return;
    if (state.selectedHourId == null || state.selectedDateId == null) {
      emit(state.copyWith(
        status: BookingStatus.failure,
        message: 'Please select an hour and a date.',
      ));
      return;
    }

    emit(state.copyWith(status: BookingStatus.booking));
    // simulam trimiterea rezervarii catre server
    await Future.delayed(bookingDelay);
    if (isClosed) return;

    final hour = _label(details.workingHours, state.selectedHourId);
    final date = _label(details.dates, state.selectedDateId);
    emit(state.copyWith(
      status: BookingStatus.success,
      message: 'Booked with ${details.doctor.name} on $date at $hour',
    ));
  }

  String _label(SlotGroup group, String? id) =>
      group.slots.firstWhere((s) => s.id == id, orElse: () => group.slots.first).label;
}
