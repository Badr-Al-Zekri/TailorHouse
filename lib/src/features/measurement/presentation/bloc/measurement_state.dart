part of 'measurement_bloc.dart';

/// Base class for measurement states
abstract class MeasurementState extends Equatable {
  const MeasurementState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MeasurementInitial extends MeasurementState {}

/// Loading state
class MeasurementLoading extends MeasurementState {}

/// State when measurement is loaded
class MeasurementLoaded extends MeasurementState {
  final Measurement measurement;

  const MeasurementLoaded(this.measurement);

  @override
  List<Object?> get props => [measurement];
}

/// State when measurement is added
class MeasurementAdded extends MeasurementState {
  final Measurement measurement;
  final Order updatedOrder;

  const MeasurementAdded(this.measurement, this.updatedOrder);

  @override
  List<Object?> get props => [measurement, updatedOrder];
}

/// State when measurement images are stored
class MeasurementImagesStored extends MeasurementState {
  final List<String> storedPaths;

  const MeasurementImagesStored(this.storedPaths);

  @override
  List<Object?> get props => [storedPaths];
}

/// State when measurement not found
class MeasurementNotFound extends MeasurementState {}

/// Error state
class MeasurementError extends MeasurementState {
  final String message;

  const MeasurementError(this.message);

  @override
  List<Object?> get props => [message];
}

