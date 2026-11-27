import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/result.dart';
import '../../domain/entities/appointment_details.dart';
import '../../domain/entities/home_feed.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_remote_data_source.dart';

// Implementarea contractului din Domain.
// 1. cere datele de la data source (HTTP)
// 2. transforma DTO-urile in entitati Domain (toEntity)
// 3. transforma exceptiile in Failure-uri (Result)
class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource remoteDataSource;

  const HealthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<HomeFeed>> getHomeFeed() =>
      _guard(() async => (await remoteDataSource.fetchHomeFeed()).toEntity());

  @override
  Future<Result<AppointmentDetails>> getAppointmentDetails() => _guard(
      () async => (await remoteDataSource.fetchAppointmentDetails()).toEntity());

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return ResultSuccess(await action());
    } on ServerException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return ResultFailure(NetworkFailure(e.message));
    } on ParsingException catch (e) {
      return ResultFailure(ParsingFailure(e.message));
    } catch (e) {
      // de ex. pe web, cand browserul blocheaza cererea (CORS)
      return ResultFailure(NetworkFailure(e.toString()));
    }
  }
}
