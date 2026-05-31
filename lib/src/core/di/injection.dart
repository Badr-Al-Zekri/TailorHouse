import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tailorhouse/src/core/network/network_info.dart';
import 'package:tailorhouse/src/infrastructure/infrastructure.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/application/application.dart';
import 'package:tailorhouse/src/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailorhouse/src/features/measurement/presentation/bloc/measurement_bloc.dart';
import 'package:tailorhouse/src/features/customer/presentation/bloc/customer_bloc.dart';
import 'package:tailorhouse/src/features/workflow/presentation/bloc/workflow_bloc.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Initialize Storage Service (this initializes Hive)
  final storageService = StorageService();
  await storageService.initialize();
  sl.registerSingleton<StorageService>(storageService);

  // Register core dependencies
  _registerCoreDependencies();

  // Register infrastructure (data sources, repositories)
  _registerInfrastructure();

  // Register use cases
  _registerUseCases();

  // Register BLoCs
  _registerBlocs();
}

/// Register core dependencies
void _registerCoreDependencies() {
  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Dio for HTTP requests
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = 'https://api.tailorhouse.com'; // TODO: Update with actual API URL
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    return dio;
  });
}

/// Register infrastructure layer (data sources, repositories)
void _registerInfrastructure() {
  // Local Data Sources
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSource(storageService: sl<StorageService>()),
  );
  sl.registerLazySingleton<CustomerLocalDataSource>(
    () => CustomerLocalDataSource(storageService: sl<StorageService>()),
  );
  sl.registerLazySingleton<MeasurementLocalDataSource>(
    () => MeasurementLocalDataSource(storageService: sl<StorageService>()),
  );
  sl.registerLazySingleton<ShopLocalDataSource>(
    () => ShopLocalDataSource(storageService: sl<StorageService>()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(storageService: sl<StorageService>()),
  );
  sl.registerLazySingleton<WorkflowLogLocalDataSource>(
    () => WorkflowLogLocalDataSource(storageService: sl<StorageService>()),
  );

  // Remote Data Sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(
      dio: sl<Dio>(),
      baseUrl: sl<Dio>().options.baseUrl,
    ),
  );
  sl.registerLazySingleton<CustomerRemoteDataSource>(
    () => CustomerRemoteDataSource(
      dio: sl<Dio>(),
      baseUrl: sl<Dio>().options.baseUrl,
    ),
  );
  sl.registerLazySingleton<MeasurementRemoteDataSource>(
    () => MeasurementRemoteDataSource(
      dio: sl<Dio>(),
      baseUrl: sl<Dio>().options.baseUrl,
    ),
  );

  // Repositories
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: sl<OrderLocalDataSource>()),
  );
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(localDataSource: sl<CustomerLocalDataSource>()),
  );
  sl.registerLazySingleton<MeasurementRepository>(
    () => MeasurementRepositoryImpl(localDataSource: sl<MeasurementLocalDataSource>()),
  );
  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(localDataSource: sl<ShopLocalDataSource>()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: sl<UserLocalDataSource>()),
  );
  sl.registerLazySingleton<WorkflowLogRepository>(
    () => WorkflowLogRepositoryImpl(localDataSource: sl<WorkflowLogLocalDataSource>()),
  );

  // Sync Service
  sl.registerLazySingleton<SyncService>(
    () => SyncService(
      networkInfo: sl<NetworkInfo>(),
      orderLocal: sl<OrderLocalDataSource>(),
      customerLocal: sl<CustomerLocalDataSource>(),
      orderRemote: sl<OrderRemoteDataSource>(),
      customerRemote: sl<CustomerRemoteDataSource>(),
      measurementRemote: sl<MeasurementRemoteDataSource>(),
    ),
  );
}

/// Register use cases
void _registerUseCases() {
  // Order Use Cases
  sl.registerLazySingleton(() => CreateOrderUseCase(
        orderRepository: sl<OrderRepository>(),
        shopRepository: sl<ShopRepository>(),
      ));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(
        orderRepository: sl<OrderRepository>(),
        workflowStateMachine: const WorkflowStateMachine(),
      ));
  sl.registerLazySingleton(() => GetOrdersByStatusUseCase(
        orderRepository: sl<OrderRepository>(),
      ));
  sl.registerLazySingleton(() => SearchOrdersUseCase(
        orderRepository: sl<OrderRepository>(),
      ));
  sl.registerLazySingleton(() => AddMeasurementUseCase(
        measurementRepository: sl<MeasurementRepository>(),
        orderRepository: sl<OrderRepository>(),
      ));
  sl.registerLazySingleton(() => TransitionWorkflowUseCase(
        orderRepository: sl<OrderRepository>(),
        workflowLogRepository: sl<WorkflowLogRepository>(),
      ));
  sl.registerLazySingleton(() => GetWorkerQueueUseCase(
        orderRepository: sl<OrderRepository>(),
      ));
  sl.registerLazySingleton(() => CustomerViewOrderUseCase(
        orderRepository: sl<OrderRepository>(),
        shopRepository: sl<ShopRepository>(),
      ));
}

/// Register BLoCs (using factory for stateful BLoCs)
void _registerBlocs() {
  // Order BLoC - factory because each screen needs its own instance
  sl.registerFactory(() => OrderBloc(
        createOrderUseCase: sl<CreateOrderUseCase>(),
        getOrderDetailsUseCase: sl<GetOrderDetailsUseCase>(),
        getOrdersByStatusUseCase: sl<GetOrdersByStatusUseCase>(),
        searchOrdersUseCase: sl<SearchOrdersUseCase>(),
        transitionWorkflowUseCase: sl<TransitionWorkflowUseCase>(),
      ));

  // Measurement BLoC
  sl.registerFactory(() => MeasurementBloc(
        addMeasurementUseCase: sl<AddMeasurementUseCase>(),
        measurementRepository: sl<MeasurementRepository>(),
      ));

  // Customer BLoC
  sl.registerFactory(() => CustomerBloc(
        customerRepository: sl<CustomerRepository>(),
      ));

  // Workflow BLoC
  sl.registerFactory(() => WorkflowBloc(
        getWorkerQueueUseCase: sl<GetWorkerQueueUseCase>(),
        transitionWorkflowUseCase: sl<TransitionWorkflowUseCase>(),
      ));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
