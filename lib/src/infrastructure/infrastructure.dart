// Infrastructure layer barrel file
//
// This layer implements the abstract interfaces defined in the domain layer.
// It contains:
// - Data models (Hive adapters for local storage)
// - Data sources (local and remote)
// - Repository implementations
// - Services (storage, sync, etc.)

// Models (DTOs with Hive adapters)
export 'models/shop_model.dart';
export 'models/customer_model.dart';
export 'models/measurement_model.dart';
export 'models/workflow_log_model.dart';
export 'models/order_model.dart';
export 'models/user_model.dart';

// Local Data Sources
export 'datasources/local/order_local_datasource.dart';
export 'datasources/local/customer_local_datasource.dart';
export 'datasources/local/measurement_local_datasource.dart';
export 'datasources/local/shop_local_datasource.dart';
export 'datasources/local/user_local_datasource.dart';
export 'datasources/local/workflow_log_local_datasource.dart';

// Remote Data Sources
export 'datasources/remote/order_remote_datasource.dart';
export 'datasources/remote/customer_remote_datasource.dart';
export 'datasources/remote/measurement_remote_datasource.dart';

// Repository Implementations
export 'repositories/order_repository_impl.dart';
export 'repositories/customer_repository_impl.dart';
export 'repositories/measurement_repository_impl.dart';
export 'repositories/shop_repository_impl.dart';
export 'repositories/user_repository_impl.dart';
export 'repositories/workflow_log_repository_impl.dart';

// Services
export 'services/storage_service.dart';
export 'services/sync_service.dart';

