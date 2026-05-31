import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tailorhouse/src/application/application.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'measurement_event.dart';
part 'measurement_state.dart';

/// BLoC for managing measurement operations
class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  final AddMeasurementUseCase _addMeasurementUseCase;
  final MeasurementRepository _measurementRepository;

  MeasurementBloc({
    required AddMeasurementUseCase addMeasurementUseCase,
    required MeasurementRepository measurementRepository,
  })  : _addMeasurementUseCase = addMeasurementUseCase,
        _measurementRepository = measurementRepository,
        super(MeasurementInitial()) {
    on<AddMeasurementEvent>(_onAddMeasurement);
    on<GetMeasurementEvent>(_onGetMeasurement);
    on<StoreMeasurementImagesEvent>(_onStoreMeasurementImages);
  }

  Future<void> _onAddMeasurement(
    AddMeasurementEvent event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(MeasurementLoading());

    final result = await _addMeasurementUseCase.execute(
      AddMeasurementInput(
        orderId: event.orderId,
        height: event.height,
        shoulder: event.shoulder,
        chest: event.chest,
        waist: event.waist,
        hips: event.hips,
        sleeveLength: event.sleeveLength,
        trouserLength: event.trouserLength,
        thobeLength: event.thobeLength,
        neck: event.neck,
        armLength: event.armLength,
        wrist: event.wrist,
        inseam: event.inseam,
        customMeasurements: event.customMeasurements,
        imagePaths: event.imagePaths,
        isAiMeasurement: event.isAiMeasurement,
        aiConfidenceScores: event.aiConfidenceScores,
        measuredByUserId: event.measuredByUserId,
        notes: event.notes,
      ),
    );

    result.fold(
      onSuccess: (output) => emit(MeasurementAdded(output.measurement, output.updatedOrder)),
      onFailure: (failure) => emit(MeasurementError(failure.message)),
    );
  }

  Future<void> _onGetMeasurement(
    GetMeasurementEvent event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(MeasurementLoading());

    try {
      final measurement = await _measurementRepository.getByOrderId(event.orderId);
      if (measurement != null) {
        emit(MeasurementLoaded(measurement));
      } else {
        emit(MeasurementNotFound());
      }
    } catch (e) {
      emit(MeasurementError('Failed to get measurement: $e'));
    }
  }

  Future<void> _onStoreMeasurementImages(
    StoreMeasurementImagesEvent event,
    Emitter<MeasurementState> emit,
  ) async {
    emit(MeasurementLoading());

    try {
      final storedPaths = await _measurementRepository.storeImages(
        event.measurementId,
        event.imagePaths,
      );
      emit(MeasurementImagesStored(storedPaths));
    } catch (e) {
      emit(MeasurementError('Failed to store images: $e'));
    }
  }
}

