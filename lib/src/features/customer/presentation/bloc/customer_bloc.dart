import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'customer_event.dart';
part 'customer_state.dart';

/// BLoC for managing customer operations
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _customerRepository;

  CustomerBloc({
    required CustomerRepository customerRepository,
  })  : _customerRepository = customerRepository,
        super(CustomerInitial()) {
    on<GetOrCreateCustomerEvent>(_onGetOrCreateCustomer);
    on<GetCustomerEvent>(_onGetCustomer);
    on<SearchCustomersEvent>(_onSearchCustomers);
    on<GetAllCustomersEvent>(_onGetAllCustomers);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
  }

  Future<void> _onGetOrCreateCustomer(
    GetOrCreateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      final customer = await _customerRepository.getOrCreate(
        shopId: event.shopId,
        name: event.name,
        phone: event.phone,
      );
      emit(CustomerLoaded(customer));
    } catch (e) {
      emit(CustomerError('Failed to get or create customer: $e'));
    }
  }

  Future<void> _onGetCustomer(
    GetCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      final customer = await _customerRepository.getById(event.customerId);
      if (customer != null) {
        emit(CustomerLoaded(customer));
      } else {
        emit(CustomerNotFound());
      }
    } catch (e) {
      emit(CustomerError('Failed to get customer: $e'));
    }
  }

  Future<void> _onSearchCustomers(
    SearchCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      final customers = await _customerRepository.search(event.shopId, event.query);
      emit(CustomersLoaded(customers));
    } catch (e) {
      emit(CustomerError('Failed to search customers: $e'));
    }
  }

  Future<void> _onGetAllCustomers(
    GetAllCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      final customers = await _customerRepository.getAll(event.shopId);
      emit(CustomersLoaded(customers));
    } catch (e) {
      emit(CustomerError('Failed to get customers: $e'));
    }
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      final updated = await _customerRepository.update(event.customer);
      emit(CustomerLoaded(updated));
    } catch (e) {
      emit(CustomerError('Failed to update customer: $e'));
    }
  }
}

