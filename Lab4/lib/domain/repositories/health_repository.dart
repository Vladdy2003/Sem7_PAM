import '../../core/result.dart';
import '../entities/appointment_details.dart';
import '../entities/home_feed.dart';

// Contractul repository-ului, definit in Domain.
// Domain spune CE date ii trebuie; stratul Data decide DE UNDE le ia
// (aici: din REST API). Implementarea: data/repositories/health_repository_impl.dart
abstract class HealthRepository {
  Future<Result<HomeFeed>> getHomeFeed();

  Future<Result<AppointmentDetails>> getAppointmentDetails();
}
