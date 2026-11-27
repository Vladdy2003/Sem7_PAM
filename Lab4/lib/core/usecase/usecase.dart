import '../result.dart';

// Contractul comun pentru toate cazurile de utilizare (use case-uri).
// Fiecare use case face un singur lucru si se apeleaza ca o functie: useCase(params).
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

// Pentru use case-urile care nu au nevoie de parametri.
class NoParams {
  const NoParams();
}
