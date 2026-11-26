import 'package:equatable/equatable.dart';

// Modelele pentru raspunsul GET /feed/details

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

  factory DetailsDoctor.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] as Map<String, dynamic>? ?? const {};
    return DetailsDoctor(
      name: json['name'] as String? ?? '',
      clinic: json['clinic'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      canMessage: actions['message'] as bool? ?? false,
      canCall: actions['call'] as bool? ?? false,
      canVideoCall: actions['videoCall'] as bool? ?? false,
    );
  }

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

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        label: json['label'] as String? ?? 'Payment',
        amount: (json['amount'] as num? ?? 0).toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        formatted: json['formatted'] as String? ?? '',
      );

  @override
  List<Object?> get props => [label, amount, currency, formatted];
}

class TimeSlot extends Equatable {
  final String id;
  final String label;
  final bool selected;

  const TimeSlot({required this.id, required this.label, this.selected = false});

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        id: json['id'] as String,
        label: json['label'] as String? ?? '',
        selected: json['selected'] as bool? ?? false,
      );

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

  factory SlotGroup.fromJson(Map<String, dynamic> json) => SlotGroup(
        title: json['title'] as String? ?? '',
        showAll: json['showAll'] as bool? ?? false,
        slots: (json['slots'] as List<dynamic>? ?? [])
            .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Id-ul slotului marcat "selected" in JSON (sau primul, daca nu exista).
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

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    final details = json['details'] as Map<String, dynamic>? ?? const {};
    final book = (json['actions'] as Map<String, dynamic>?)?['bookAppointment']
            as Map<String, dynamic>? ??
        const {};
    return AppointmentDetails(
      title: json['title'] as String? ?? 'Appointment',
      doctor: DetailsDoctor.fromJson(json['doctor'] as Map<String, dynamic>),
      payment: Payment.fromJson(json['payment'] as Map<String, dynamic>),
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      workingHours:
          SlotGroup.fromJson(json['workingHours'] as Map<String, dynamic>),
      dates: SlotGroup.fromJson(json['date'] as Map<String, dynamic>),
      bookLabel: book['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }

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
