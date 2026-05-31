/// Garment workflow status - strict 8-stage state machine
/// 
/// Each garment MUST move through these states in strict order.
/// Skipping stages is NOT allowed.
/// 
/// Flow: CREATED → MEASURED → CUTTING → SEWING → BUTTONING → IRONING → READY → DELIVERED
enum GarmentStatus {
  /// Initial state when order is created
  created(
    order: 0,
    arabicName: 'تم الإنشاء',
    englishName: 'Created',
  ),

  /// Customer has been measured (AI or manual)
  measured(
    order: 1,
    arabicName: 'تم القياس',
    englishName: 'Measured',
  ),

  /// Fabric is being cut by the cutter
  cutting(
    order: 2,
    arabicName: 'القص',
    englishName: 'Cutting',
  ),

  /// Garment is being sewn by the tailor
  sewing(
    order: 3,
    arabicName: 'الخياطة',
    englishName: 'Sewing',
  ),

  /// Buttons and finishing touches
  buttoning(
    order: 4,
    arabicName: 'التزرير',
    englishName: 'Buttoning',
  ),

  /// Final ironing and pressing
  ironing(
    order: 5,
    arabicName: 'الكي',
    englishName: 'Ironing',
  ),

  /// Garment is ready for pickup/delivery
  ready(
    order: 6,
    arabicName: 'جاهز',
    englishName: 'Ready',
  ),

  /// Garment has been delivered to customer
  delivered(
    order: 7,
    arabicName: 'تم التسليم',
    englishName: 'Delivered',
  );

  final int order;
  final String arabicName;
  final String englishName;

  const GarmentStatus({
    required this.order,
    required this.arabicName,
    required this.englishName,
  });

  /// Check if this status can transition to the target status
  /// Only allows moving to the IMMEDIATE next status
  bool canTransitionTo(GarmentStatus target) {
    return target.order == order + 1;
  }

  /// Get the next status in the workflow
  /// Returns null if already at final status (delivered)
  GarmentStatus? get nextStatus {
    if (this == GarmentStatus.delivered) return null;
    return GarmentStatus.values.firstWhere((s) => s.order == order + 1);
  }

  /// Get the previous status in the workflow
  /// Returns null if at initial status (created)
  GarmentStatus? get previousStatus {
    if (this == GarmentStatus.created) return null;
    return GarmentStatus.values.firstWhere((s) => s.order == order - 1);
  }

  /// Check if this is a terminal state
  bool get isTerminal => this == GarmentStatus.delivered;

  /// Check if this is the initial state
  bool get isInitial => this == GarmentStatus.created;

  /// Check if garment is still in active workflow (not delivered)
  bool get isInProgress => !isTerminal;

  /// Get all statuses that come after this one
  List<GarmentStatus> get remainingStatuses {
    return GarmentStatus.values.where((s) => s.order > order).toList();
  }

  /// Get all statuses that have been completed (including current)
  List<GarmentStatus> get completedStatuses {
    return GarmentStatus.values.where((s) => s.order <= order).toList();
  }

  /// Get progress percentage (0.0 to 1.0)
  double get progressPercentage => order / (GarmentStatus.values.length - 1);
}

