import 'package:equatable/equatable.dart';

// Erorile vazute de Domain si Presentation. Nu depind de HTTP sau JSON:
// UI-ul stie doar ca "ceva a esuat" si ce mesaj sa arate.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}
