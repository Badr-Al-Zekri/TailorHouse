import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for adding measurements to an order
class AddMeasurementInput {
  final String orderId;

  /// Basic measurements (all in cm)
  final double? height;
  final double? shoulder;
  final double? chest;
  final double? waist;
  final double? hips;
  final double? sleeveLength;
  final double? trouserLength;
  final double? thobeLength;
  final double? neck;
  final double? armLength;
  final double? wrist;
  final double? inseam;

  /// Custom measurements
  final Map<String, double>? customMeasurements;

  /// Image paths (front, side, back)
  final List<String>? imagePaths;

  /// Measurement source info
  final bool isAiMeasurement;
  final Map<String, double>? aiConfidenceScores;

  /// User performing the measurement
  final String measuredByUserId;

  /// Notes
  final String? notes;

  const AddMeasurementInput({
    required this.orderId,
    this.height,
    this.shoulder,
    this.chest,
    this.waist,
    this.hips,
    this.sleeveLength,
    this.trouserLength,
    this.thobeLength,
    this.neck,
    this.armLength,
    this.wrist,
    this.inseam,
    this.customMeasurements,
    this.imagePaths,
    this.isAiMeasurement = false,
    this.aiConfidenceScores,
    required this.measuredByUserId,
    this.notes,
  });
}

/// Output after adding measurements
class AddMeasurementOutput {
  final Order updatedOrder;
  final Measurement measurement;
  final bool readyForNextStage;

  const AddMeasurementOutput({
    required this.updatedOrder,
    required this.measurement,
    required this.readyForNextStage,
  });
}

/// Use case for adding measurements to an order
/// 
/// Business Flow:
/// 1. Get order by ID
/// 2. Validate order is in CREATED status
/// 3. Create measurement entity
/// 4. Validate measurements for garment type
/// 5. Store measurement images (if any)
/// 6. Add measurement to order
/// 7. Persist changes
class AddMeasurementUseCase implements UseCase<AddMeasurementInput, Result<AddMeasurementOutput>> {
  final OrderRepository _orderRepository;
  final MeasurementRepository _measurementRepository;

  AddMeasurementUseCase({
    required OrderRepository orderRepository,
    required MeasurementRepository measurementRepository,
  })  : _orderRepository = orderRepository,
        _measurementRepository = measurementRepository;

  @override
  Future<Result<AddMeasurementOutput>> execute(AddMeasurementInput input) async {
    try {
      // 1. Get order
      final order = await _orderRepository.getById(input.orderId);
      if (order == null) {
        return Result.failure(NotFoundFailure(
          entityType: 'Order',
          entityId: input.orderId,
        ));
      }

      // 2. Validate order status
      if (order.status != GarmentStatus.created) {
        return Result.failure(WorkflowFailure(
          message: 'Measurements can only be added in CREATED status',
          arabicMessage: 'لا يمكن إضافة القياسات إلا في حالة الإنشاء',
        ));
      }

      // 3. Create measurement entity
      final measurementId = _generateMeasurementId();
      final measurement = _buildMeasurement(measurementId, input);

      // 4. Validate measurements for garment type
      try {
        measurement.validateForGarmentType(order.garmentType);
      } on MissingRequiredMeasurementsException catch (e) {
        return Result.failure(ValidationFailure(
          message: e.message,
          arabicMessage: e.arabicMessage,
          field: 'measurements',
        ));
      }

      // 5. Store images if provided
      List<String> storedImagePaths = [];
      if (input.imagePaths != null && input.imagePaths!.isNotEmpty) {
        storedImagePaths = await _measurementRepository.storeImages(
          measurementId,
          input.imagePaths!,
        );
      }

      // Update measurement with stored image paths
      final measurementWithImages = measurement.copyWith(
        imagePaths: storedImagePaths,
      );

      // 6. Persist measurement
      await _measurementRepository.create(measurementWithImages);

      // 7. Add measurement to order
      final updatedOrder = order.addMeasurement(measurementWithImages);

      // 8. Persist order
      final savedOrder = await _orderRepository.update(updatedOrder);

      return Result.success(AddMeasurementOutput(
        updatedOrder: savedOrder,
        measurement: measurementWithImages,
        readyForNextStage: true,
      ));
    } on DomainException catch (e) {
      return Result.failure(Failure(
        message: e.message,
        arabicMessage: e.arabicMessage,
        originalError: e,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to add measurement: $e',
        arabicMessage: 'فشل في إضافة القياسات',
      ));
    }
  }

  Measurement _buildMeasurement(String id, AddMeasurementInput input) {
    MeasurementValue? buildValue(double? value, String field) {
      if (value == null) return null;

      if (input.isAiMeasurement && input.aiConfidenceScores != null) {
        final confidence = input.aiConfidenceScores![field] ?? 0.8;
        return MeasurementValue.fromAi(value, confidence);
      }
      return MeasurementValue.manual(value);
    }

    Map<String, MeasurementValue>? buildCustom() {
      if (input.customMeasurements == null) return null;
      return input.customMeasurements!.map(
        (key, value) => MapEntry(key, buildValue(value, key)!),
      );
    }

    return Measurement.create(
      id: id,
      orderId: input.orderId,
      measuredBy: input.measuredByUserId,
      height: buildValue(input.height, 'height'),
      shoulder: buildValue(input.shoulder, 'shoulder'),
      chest: buildValue(input.chest, 'chest'),
      waist: buildValue(input.waist, 'waist'),
      hips: buildValue(input.hips, 'hips'),
      sleeveLength: buildValue(input.sleeveLength, 'sleeveLength'),
      trouserLength: buildValue(input.trouserLength, 'trouserLength'),
      thobeLength: buildValue(input.thobeLength, 'thobeLength'),
      neck: buildValue(input.neck, 'neck'),
      armLength: buildValue(input.armLength, 'armLength'),
      wrist: buildValue(input.wrist, 'wrist'),
      inseam: buildValue(input.inseam, 'inseam'),
      customMeasurements: buildCustom(),
      imagePaths: input.imagePaths ?? [],
      notes: input.notes,
    );
  }

  String _generateMeasurementId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'MEAS_$timestamp';
  }
}

