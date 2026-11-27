import '../../core/result.dart';
import '../../core/usecase/usecase.dart';
import '../entities/home_feed.dart';
import '../repositories/health_repository.dart';

// Use case: obtine datele pentru ecranul principal.
class GetHomeFeed implements UseCase<HomeFeed, NoParams> {
  final HealthRepository repository;

  const GetHomeFeed(this.repository);

  @override
  Future<Result<HomeFeed>> call([NoParams params = const NoParams()]) =>
      repository.getHomeFeed();
}
