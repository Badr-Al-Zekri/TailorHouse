// Application Layer - TailorHouse
//
// This layer contains use cases that orchestrate the domain logic.
// Use cases:
// - Coordinate between repositories
// - Enforce application-level validation
// - Transform data for the presentation layer
// - Handle cross-cutting concerns
//
// Use cases do NOT contain business rules - those belong in the domain layer.

// ============================================
// Common
// ============================================
export 'common/use_case.dart';

// ============================================
// Order Use Cases
// ============================================
export 'use_cases/order/create_order_use_case.dart';
export 'use_cases/order/add_measurement_use_case.dart';
export 'use_cases/order/get_order_details_use_case.dart';
export 'use_cases/order/get_orders_by_status_use_case.dart';
export 'use_cases/order/search_orders_use_case.dart';

// ============================================
// Workflow Use Cases
// ============================================
export 'use_cases/workflow/transition_workflow_use_case.dart';
export 'use_cases/workflow/get_worker_queue_use_case.dart';

// ============================================
// Customer Use Cases
// ============================================
export 'use_cases/customer/customer_view_order_use_case.dart';

