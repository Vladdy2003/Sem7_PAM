import 'package:equatable/equatable.dart';

// Entitatile Domain pentru ecranul de programare (vin din GET /feed/details).

class DetailsDoctor extends Equatable {
  final String name;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;

  const DetailsDoctor({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    this.canMessage = true,
    this.canCall = true,
    this.canVideoCall = true,
  });

  DetailsDoctor copyWith({String? name, String? clinic, String? avatarUrl}) =>
      DetailsDoctor(
        name: name ?? this.name,
        clinic: clinic ?? this.clinic,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        canMessage: canMessage,
        canCall: canCall,
        canVideoCall: canVideoCall,
      );

  @override
  List<Object?> get props =>
      [name, clinic, avatarUrl, canMessage, canCall, canVideoCall];
}

class Payment extends Equatable {
  final String label;
  final double amount;
  final String currency;
  final String formatted;

  const Payment({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  @override
  List<Object?> get props => [label, amount, currency, formatted];
}

class TimeSlot extends Equatable {
  final String id;
  final String label;
  final bool selected;

  const TimeSlot({required this.id, required this.label, this.selected = false});

  @override
  List<Object?> get props => [id, label, selected];
}

class SlotGroup extends Equatable {
  final String title;
  final bool showAll;
  final List<TimeSlot> slots;

  const SlotGroup({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  /// Id-ul slotului marcat "selected" de server (sau primul, daca nu exista).
  String? get initialSelectedId {
    for (final s in slots) {
      if (s.selected) return s.id;
    }
    return slots.isEmpty ? null : slots.first.id;
  }

  @override
  List<Object?> get props => [title, showAll, slots];
}

class AppointmentDetails extends Equatable {
  final String title;
  final DetailsDoctor doctor;
  final Payment payment;
  final String detailsTitle;
  final String description;
  final SlotGroup workingHours;
  final SlotGroup dates;
  final String bookLabel;
  final bool bookEnabled;

  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.payment,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  /// Acelasi sablon de detalii, dar pentru alt doctor (din lista "Nearby").
  AppointmentDetails forDoctor(DetailsDoctor other) => AppointmentDetails(
        title: title,
        doctor: other,
        payment: payment,
        detailsTitle: detailsTitle,
        description: description,
        workingHours: workingHours,
        dates: dates,
        bookLabel: bookLabel,
        bookEnabled: bookEnabled,
      );

  @override
  List<Object?> get props => [
        title,
        doctor,
        payment,
        detailsTitle,
        description,
        workingHours,
        dates,
        bookLabel,
        bookEnabled,
      ];
}
