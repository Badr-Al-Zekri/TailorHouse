part of 'workflow_bloc.dart';

/// Base class for workflow states
abstract class WorkflowState extends Equatable {
  const WorkflowState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WorkflowInitial extends WorkflowState {}

/// Loading state
class WorkflowLoading extends WorkflowState {}

/// State when worker queue is loaded
class WorkerQueueLoaded extends WorkflowState {
  final GetWorkerQueueOutput output;

  const WorkerQueueLoaded(this.output);

  @override
  List<Object?> get props => [output];
}

/// State when workflow is transitioned
class WorkflowTransitioned extends WorkflowState {
  final TransitionWorkflowOutput output;

  const WorkflowTransitioned(this.output);

  @override
  List<Object?> get props => [output];
}

/// Error state
class WorkflowError extends WorkflowState {
  final String message;

  const WorkflowError(this.message);

  @override
  List<Object?> get props => [message];
}

