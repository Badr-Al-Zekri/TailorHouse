/// User roles for role-based access control
/// 
/// Each role has specific permissions and views in the system.
enum UserRole {
  /// Shop owner - full access to all features
  owner(
    arabicName: 'صاحب المحل',
    englishName: 'Owner',
    canCreateOrders: true,
    canViewAllOrders: true,
    canManageWorkers: true,
    canViewReports: true,
    canTransitionAnyStatus: true,
  ),

  /// Shop staff - can create orders and manage workflow
  staff(
    arabicName: 'موظف',
    englishName: 'Staff',
    canCreateOrders: true,
    canViewAllOrders: true,
    canManageWorkers: false,
    canViewReports: false,
    canTransitionAnyStatus: true,
  ),

  /// Cutter worker - handles cutting stage only
  cutter(
    arabicName: 'قصّاص',
    englishName: 'Cutter',
    canCreateOrders: false,
    canViewAllOrders: false,
    canManageWorkers: false,
    canViewReports: false,
    canTransitionAnyStatus: false,
    allowedTransitions: [GarmentStatusTransition.measuredToCutting, GarmentStatusTransition.cuttingToSewing],
  ),

  /// Tailor worker - handles sewing stage only
  tailor(
    arabicName: 'خيّاط',
    englishName: 'Tailor',
    canCreateOrders: false,
    canViewAllOrders: false,
    canManageWorkers: false,
    canViewReports: false,
    canTransitionAnyStatus: false,
    allowedTransitions: [GarmentStatusTransition.cuttingToSewing, GarmentStatusTransition.sewingToButtoning],
  ),

  /// Buttoning worker - handles buttoning/finishing stage
  buttonWorker(
    arabicName: 'عامل تزرير',
    englishName: 'Button Worker',
    canCreateOrders: false,
    canViewAllOrders: false,
    canManageWorkers: false,
    canViewReports: false,
    canTransitionAnyStatus: false,
    allowedTransitions: [GarmentStatusTransition.sewingToButtoning, GarmentStatusTransition.buttoningToIroning],
  ),

  /// Ironing worker - handles final ironing stage
  ironWorker(
    arabicName: 'عامل كي',
    englishName: 'Iron Worker',
    canCreateOrders: false,
    canViewAllOrders: false,
    canManageWorkers: false,
    canViewReports: false,
    canTransitionAnyStatus: false,
    allowedTransitions: [GarmentStatusTransition.buttoningToIroning, GarmentStatusTransition.ironingToReady],
  ),

  /// Customer - view only access to their own orders
  customer(
    arabicName: 'زبون',
    englishName: 'Customer',
    canCreateOrders: false,
    canViewAllOrders: false,
    canManageWorkers: false,
    canViewReports: false,
    canTransitionAnyStatus: false,
  );

  final String arabicName;
  final String englishName;
  final bool canCreateOrders;
  final bool canViewAllOrders;
  final bool canManageWorkers;
  final bool canViewReports;
  final bool canTransitionAnyStatus;
  final List<GarmentStatusTransition> allowedTransitions;

  const UserRole({
    required this.arabicName,
    required this.englishName,
    required this.canCreateOrders,
    required this.canViewAllOrders,
    required this.canManageWorkers,
    required this.canViewReports,
    required this.canTransitionAnyStatus,
    this.allowedTransitions = const [],
  });

  /// Check if this role can perform a specific transition
  bool canPerformTransition(GarmentStatusTransition transition) {
    if (canTransitionAnyStatus) return true;
    return allowedTransitions.contains(transition);
  }

  /// Check if this role is a worker role
  bool get isWorker => this == cutter || this == tailor || this == buttonWorker || this == ironWorker;

  /// Check if this role is a shop role (owner or staff)
  bool get isShopRole => this == owner || this == staff;
}

/// Enumeration of valid status transitions
/// Used for role-based permission checks
enum GarmentStatusTransition {
  createdToMeasured,
  measuredToCutting,
  cuttingToSewing,
  sewingToButtoning,
  buttoningToIroning,
  ironingToReady,
  readyToDelivered,
}

