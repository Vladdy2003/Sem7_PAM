import '../../core/result.dart';
import '../../core/usecase/usecase.dart';
import '../entities/appointment_details.dart';
import '../repositories/health_repository.dart';

// Use case: obtine detaliile pentru ecranul de programare.
class GetAppointmentDetails implements UseCase<AppointmentDetails, NoParams> {
  final HealthRepository repository;

  const GetAppointmentDetails(this.repository);

  @override
  Future<Result<AppointmentDetails>> call(
          [NoParams params = const NoParams()]) =>
      repository.getAppointmentDetails();
}
