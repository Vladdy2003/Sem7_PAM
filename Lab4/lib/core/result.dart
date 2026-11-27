import 'error/failures.dart';

// Rezultatul unei operatii: fie date (Success), fie o eroare (Failure).
// Astfel erorile circula ca valori, nu ca exceptii, intre straturi.
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        ResultSuccess<T>(:final data) => onSuccess(data),
        ResultFailure<T>(:final failure) => onFailure(failure),
      };
}

final class ResultSuccess<T> extends Result<T> {
  final T data;
  const ResultSuccess(this.data);
}

final class ResultFailure<T> extends Result<T> {
  final Failure failure;
  const ResultFailure(this.failure);
}
