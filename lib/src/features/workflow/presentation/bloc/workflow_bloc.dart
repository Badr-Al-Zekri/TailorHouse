import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tailorhouse/src/application/application.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'workflow_event.dart';
part 'workflow_state.dart';

/// BLoC for managing workflow operations (worker queues, transitions)
class WorkflowBloc extends Bloc<WorkflowEvent, WorkflowState> {
  final GetWorkerQueueUseCase _getWorkerQueueUseCase;
  final TransitionWorkflowUseCase _transitionWorkflowUseCase;

  WorkflowBloc({
    required GetWorkerQueueUseCase getWorkerQueueUseCase,
    required TransitionWorkflowUseCase transitionWorkflowUseCase,
  })  : _getWorkerQueueUseCase = getWorkerQueueUseCase,
        _transitionWorkflowUseCase = transitionWorkflowUseCase,
        super(WorkflowInitial()) {
    on<GetWorkerQueueEvent>(_onGetWorkerQueue);
    on<TransitionWorkflowEvent>(_onTransitionWorkflow);
    on<MoveToNextStatusEvent>(_onMoveToNextStatus);
  }

  Future<void> _onGetWorkerQueue(
    GetWorkerQueueEvent event,
    Emitter<WorkflowState> emit,
  ) async {
    emit(WorkflowLoading());

    final result = await _getWorkerQueueUseCase.execute(
      GetWorkerQueueInput(
        shopId: event.shopId,
        workerRole: event.workerRole,
      ),
    );

    result.fold(
      onSuccess: (output) => emit(WorkerQueueLoaded(output)),
      onFailure: (failure) => emit(WorkflowError(failure.message)),
    );
  }

  Future<void> _onTransitionWorkflow(
    TransitionWorkflowEvent event,
    Emitter<WorkflowState> emit,
  ) async {
    emit(WorkflowLoading());

    final result = await _transitionWorkflowUseCase.execute(
      TransitionWorkflowInput(
        orderId: event.orderId,
        targetStatus: event.targetStatus,
        userId: event.userId,
        userName: event.userName,
        userRole: event.userRole,
        notes: event.notes,
      ),
    );

    result.fold(
      onSuccess: (output) => emit(WorkflowTransitioned(output)),
      onFailure: (failure) => emit(WorkflowError(failure.message)),
    );
  }

  Future<void> _onMoveToNextStatus(
    MoveToNextStatusEvent event,
    Emitter<WorkflowState> emit,
  ) async {
    emit(WorkflowLoading());

    // Get current order to determine next status
    // This would typically use GetOrderDetailsUseCase
    // For now, we'll use TransitionWorkflowUseCase directly
    // In a full implementation, we'd use MoveToNextStatusUseCase
    
    // This is a simplified version - in production, use MoveToNextStatusUseCase
    final result = await _transitionWorkflowUseCase.execute(
      TransitionWorkflowInput(
        orderId: event.orderId,
        targetStatus: event.nextStatus,
        userId: event.userId,
        userName: event.userName,
        userRole: event.userRole,
        notes: event.notes,
      ),
    );

    result.fold(
      onSuccess: (output) => emit(WorkflowTransitioned(output)),
      onFailure: (failure) => emit(WorkflowError(failure.message)),
    );
  }
}

