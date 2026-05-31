part of 'customer_bloc.dart';

/// Base class for customer events
abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get or create customer
class GetOrCreateCustomerEvent extends CustomerEvent {
  final String shopId;
  final String name;
  final String phone;

  const GetOrCreateCustomerEvent({
    required this.shopId,
    required this.name,
    required this.phone,
  });

  @override
  List<Object?> get props => [shopId, name, phone];
}

/// Event to get customer by ID
class GetCustomerEvent extends CustomerEvent {
  final String customerId;

  const GetCustomerEvent({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

/// Event to search customers
class SearchCustomersEvent extends CustomerEvent {
  final String shopId;
  final String query;

  const SearchCustomersEvent({
    required this.shopId,
    required this.query,
  });

  @override
  List<Object?> get props => [shopId, query];
}

/// Event to get all customers
class GetAllCustomersEvent extends CustomerEvent {
  final String shopId;

  const GetAllCustomersEvent({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

/// Event to update customer
class UpdateCustomerEvent extends CustomerEvent {
  final Customer customer;

  const UpdateCustomerEvent({required this.customer});

  @override
  List<Object?> get props => [customer];
}

