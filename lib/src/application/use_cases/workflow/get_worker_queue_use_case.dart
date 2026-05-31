import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for getting a worker's queue
class GetWorkerQueueInput {
  final String shopId;
  final UserRole workerRole;

  const GetWorkerQueueInput({
    required this.shopId,
    required this.workerRole,
  });
}

/// Queue item for workers
class WorkerQueueItem {
  final String orderId;
  final String garmentIdDisplay;
  final String customerName;
  final GarmentType garmentType;
  final GarmentStatus currentStatus;
  final GarmentStatus targetStatus;
  final DateTime expectedDeliveryDate;
  final bool isOverdue;
  final bool isUrgent; // Expected delivery within 24 hours
  final DateTime statusEnteredAt;
  final String? notes;

  const WorkerQueueItem({
    required this.orderId,
    required this.garmentIdDisplay,
    required this.customerName,
    required this.garmentType,
    required this.currentStatus,
    required this.targetStatus,
    required this.expectedDeliveryDate,
    required this.isOverdue,
    required this.isUrgent,
    required this.statusEnteredAt,
    this.notes,
  });
}

/// Output with worker queue
class GetWorkerQueueOutput {
  final List<WorkerQueueItem> queueItems;
  final int totalCount;
  final int urgentCount;
  final int overdueCount;
  final GarmentStatus stageResponsibleFor;

  const GetWorkerQueueOutput({
    required this.queueItems,
    required this.totalCount,
    required this.urgentCount,
    required this.overdueCount,
    required this.stageResponsibleFor,
  });
}

/// Use case for getting a worker's queue
/// 
/// Workers see orders that are ready for their stage:
/// - Cutter: Orders in MEASURED status (ready for cutting)
/// - Tailor: Orders in CUTTING status (ready for sewing)
/// - Button Worker: Orders in SEWING status (ready for buttoning)
/// - Iron Worker: Orders in BUTTONING status (ready for ironing)
class GetWorkerQueueUseCase implements UseCase<GetWorkerQueueInput, Result<GetWorkerQueueOutput>> {
  final OrderRepository _orderRepository;

  GetWorkerQueueUseCase({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  @override
  Future<Result<GetWorkerQueueOutput>> execute(GetWorkerQueueInput input) async {
    try {
      // 1. Determine which status this worker handles
      final workingStatus = _getWorkingStatus(input.workerRole);
      if (workingStatus == null) {
        return Result.failure(PermissionFailure(
          message: 'This role does not have a worker queue',
          arabicMessage: 'هذا الدور ليس له قائمة أعمال',
        ));
      }

      // 2. Get orders at this status
      final orders = await _orderRepository.getByStatus(input.shopId, workingStatus);

      // 3. Convert to queue items
      final now = DateTime.now();
      final urgentThreshold = now.add(const Duration(hours: 24));
      
      final queueItems = orders.map((order) {
        final targetStatus = order.status.nextStatus!;
        return WorkerQueueItem(
          orderId: order.id,
          garmentIdDisplay: order.garmentId.toString(),
          customerName: order.customerName,
          garmentType: order.garmentType,
          currentStatus: order.status,
          targetStatus: targetStatus,
          expectedDeliveryDate: order.expectedDeliveryDate,
          isOverdue: order.isOverdue,
          isUrgent: order.expectedDeliveryDate.isBefore(urgentThreshold),
          statusEnteredAt: order.statusEnteredAt,
          notes: order.notes,
        );
      }).toList();

      // 4. Sort by urgency (overdue first, then urgent, then by expected date)
      queueItems.sort((a, b) {
        if (a.isOverdue && !b.isOverdue) return -1;
        if (!a.isOverdue && b.isOverdue) return 1;
        if (a.isUrgent && !b.isUrgent) return -1;
        if (!a.isUrgent && b.isUrgent) return 1;
        return a.expectedDeliveryDate.compareTo(b.expectedDeliveryDate);
      });

      // 5. Count urgent and overdue
      final urgentCount = queueItems.where((i) => i.isUrgent).length;
      final overdueCount = queueItems.where((i) => i.isOverdue).length;

      return Result.success(GetWorkerQueueOutput(
        queueItems: queueItems,
        totalCount: queueItems.length,
        urgentCount: urgentCount,
        overdueCount: overdueCount,
        stageResponsibleFor: workingStatus,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to get worker queue: $e',
        arabicMessage: 'فشل في جلب قائمة الأعمال',
      ));
    }
  }

  /// Get the status that this worker role handles
  GarmentStatus? _getWorkingStatus(UserRole role) {
    switch (role) {
      case UserRole.cutter:
        return GarmentStatus.measured; // Cutter works on MEASURED orders
      case UserRole.tailor:
        return GarmentStatus.cutting; // Tailor works on CUTTING orders
      case UserRole.buttonWorker:
        return GarmentStatus.sewing; // Button worker works on SEWING orders
      case UserRole.ironWorker:
        return GarmentStatus.buttoning; // Iron worker works on BUTTONING orders
      default:
        return null; // Non-worker roles don't have a queue
    }
  }
}

