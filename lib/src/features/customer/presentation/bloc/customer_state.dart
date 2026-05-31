part of 'customer_bloc.dart';

/// Base class for customer states
abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CustomerInitial extends CustomerState {}

/// Loading state
class CustomerLoading extends CustomerState {}

/// State when customer is loaded
class CustomerLoaded extends CustomerState {
  final Customer customer;

  const CustomerLoaded(this.customer);

  @override
  List<Object?> get props => [customer];
}

/// State when customers list is loaded
class CustomersLoaded extends CustomerState {
  final List<Customer> customers;

  const CustomersLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

/// State when customer not found
class CustomerNotFound extends CustomerState {}

/// Error state
class CustomerError extends CustomerState {
  final String message;

  const CustomerError(this.message);

  @override
  List<Object?> get props => [message];
}

