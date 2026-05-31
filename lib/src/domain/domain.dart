// Domain Layer - TailorHouse
//
// This is the core business logic layer, completely independent of:
// - UI/Presentation concerns
// - Infrastructure/Database concerns
// - External frameworks
//
// The domain layer contains:
// - Entities: Core business objects with identity
// - Value Objects: Immutable objects defined by their attributes
// - Enums: Business-level enumerations
// - Services: Domain services encapsulating business logic
// - Repositories: Abstract interfaces for data access
// - Exceptions: Domain-specific error handling

// ============================================
// Enums
// ============================================
export 'enums/garment_status.dart';
export 'enums/garment_type.dart';
export 'enums/user_role.dart';

// ============================================
// Value Objects
// ============================================
export 'value_objects/garment_id.dart';
export 'value_objects/money.dart';
export 'value_objects/phone_number.dart';
export 'value_objects/measurement_value.dart';

// ============================================
// Entities
// ============================================
export 'entities/customer.dart';
export 'entities/shop.dart';
export 'entities/measurement.dart';
export 'entities/workflow_log.dart';
export 'entities/order.dart';

// ============================================
// Domain Services
// ============================================
export 'services/workflow_state_machine.dart';

// ============================================
// Repositories (Interfaces Only)
// ============================================
export 'repositories/order_repository.dart';
export 'repositories/customer_repository.dart';
export 'repositories/measurement_repository.dart';
export 'repositories/shop_repository.dart';
export 'repositories/workflow_log_repository.dart';
export 'repositories/user_repository.dart';

// ============================================
// Exceptions
// ============================================
export 'exceptions/domain_exceptions.dart';

