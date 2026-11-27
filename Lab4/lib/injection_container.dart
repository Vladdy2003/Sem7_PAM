import 'package:http/http.dart' as http;

import 'data/datasources/health_remote_data_source.dart';
import 'data/repositories/health_repository_impl.dart';
import 'domain/repositories/health_repository.dart';

// Dependency Injection: aici se leaga straturile intre ele.
//   http.Client -> HealthRemoteDataSourceImpl -> HealthRepositoryImpl
// Restul aplicatiei vede doar interfata HealthRepository (din Domain).
HealthRepository createHealthRepository({http.Client? client}) {
  final remoteDataSource = HealthRemoteDataSourceImpl(
    client: client ?? http.Client(),
  );
  return HealthRepositoryImpl(remoteDataSource: remoteDataSource);
}
