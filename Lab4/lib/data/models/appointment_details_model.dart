import '../../domain/entities/appointment_details.dart';

// DTO-urile pentru raspunsul JSON de la GET /feed/details.
// fromJson = deserializare, toJson = serializare, toEntity = conversie spre Domain.

class DetailsDoctorModel {
  final String name;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;

  const DetailsDoctorModel({
    required this.name,
    required this.clinic,
    required this.avatarUrl,
    required this.canMessage,
    required this.canCall,
    required this.canVideoCall,
  });

  factory DetailsDoctorModel.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] as Map<String, dynamic>? ?? const {};
    return DetailsDoctorModel(
      name: json['name'] as String? ?? '',
      clinic: json['clinic'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      canMessage: actions['message'] as bool? ?? false,
      canCall: actions['call'] as bool? ?? false,
      canVideoCall: actions['videoCall'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'clinic': clinic,
        'avatarUrl': avatarUrl,
        'actions': {
          'message': canMessage,
          'call': canCall,
          'videoCall': canVideoCall,
        },
      };

  DetailsDoctor toEntity() => DetailsDoctor(
        name: name,
        clinic: clinic,
        avatarUrl: avatarUrl,
        canMessage: canMessage,
        canCall: canCall,
        canVideoCall: canVideoCall,
      );
}

class PaymentModel {
  final String label;
  final double amount;
  final String currency;
  final String formatted;

  const PaymentModel({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        label: json['label'] as String? ?? 'Payment',
        amount: (json['amount'] as num? ?? 0).toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        formatted: json['formatted'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'amount': amount,
        'currency': currency,
        'formatted': formatted,
      };

  Payment toEntity() => Payment(
        label: label,
        amount: amount,
        currency: currency,
        formatted: formatted,
      );
}

class TimeSlotModel {
  final String id;
  final String label;
  final bool selected;

  const TimeSlotModel({
    required this.id,
    required this.label,
    required this.selected,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
        id: json['id'] as String,
        label: json['label'] as String? ?? '',
        selected: json['selected'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'label': label, 'selected': selected};

  TimeSlot toEntity() => TimeSlot(id: id, label: label, selected: selected);
}

class SlotGroupModel {
  final String title;
  final bool showAll;
  final List<TimeSlotModel> slots;

  const SlotGroupModel({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  factory SlotGroupModel.fromJson(Map<String, dynamic> json) => SlotGroupModel(
        title: json['title'] as String? ?? '',
        showAll: json['showAll'] as bool? ?? false,
        slots: (json['slots'] as List<dynamic>? ?? [])
            .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'showAll': showAll,
        'slots': slots.map((e) => e.toJson()).toList(),
      };

  SlotGroup toEntity() => SlotGroup(
        title: title,
        showAll: showAll,
        slots: slots.map((e) => e.toEntity()).toList(),
      );
}

class AppointmentDetailsModel {
  final String title;
  final DetailsDoctorModel doctor;
  final PaymentModel payment;
  final String detailsTitle;
  final String description;
  final SlotGroupModel workingHours;
  final SlotGroupModel dates;
  final String bookLabel;
  final bool bookEnabled;

  const AppointmentDetailsModel({
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

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    final details = json['details'] as Map<String, dynamic>? ?? const {};
    final book = (json['actions'] as Map<String, dynamic>?)?['bookAppointment']
            as Map<String, dynamic>? ??
        const {};
    return AppointmentDetailsModel(
      title: json['title'] as String? ?? 'Appointment',
      doctor:
          DetailsDoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
      payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      workingHours:
          SlotGroupModel.fromJson(json['workingHours'] as Map<String, dynamic>),
      dates: SlotGroupModel.fromJson(json['date'] as Map<String, dynamic>),
      bookLabel: book['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'doctor': doctor.toJson(),
        'payment': payment.toJson(),
        'details': {'title': detailsTitle, 'description': description},
        'workingHours': workingHours.toJson(),
        'date': dates.toJson(),
        'actions': {
          'bookAppointment': {'label': bookLabel, 'enabled': bookEnabled},
        },
      };

  AppointmentDetails toEntity() => AppointmentDetails(
        title: title,
        doctor: doctor.toEntity(),
        payment: payment.toEntity(),
        detailsTitle: detailsTitle,
        description: description,
        workingHours: workingHours.toEntity(),
        dates: dates.toEntity(),
        bookLabel: bookLabel,
        bookEnabled: bookEnabled,
      );
}
