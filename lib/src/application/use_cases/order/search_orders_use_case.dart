import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/application/use_cases/order/get_orders_by_status_use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for searching orders
class SearchOrdersInput {
  final String shopId;
  final String query;

  const SearchOrdersInput({
    required this.shopId,
    required this.query,
  });
}

/// Output with search results
class SearchOrdersOutput {
  final List<OrderListItem> orders;
  final int totalCount;
  final String searchQuery;

  const SearchOrdersOutput({
    required this.orders,
    required this.totalCount,
    required this.searchQuery,
  });
}

/// Use case for searching orders
/// 
/// Searches by:
/// - Garment ID (e.g., "TF01-25-00001")
/// - Customer name
/// - Customer phone
class SearchOrdersUseCase implements UseCase<SearchOrdersInput, Result<SearchOrdersOutput>> {
  final OrderRepository _orderRepository;

  SearchOrdersUseCase({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  @override
  Future<Result<SearchOrdersOutput>> execute(SearchOrdersInput input) async {
    try {
      final query = input.query.trim();
      
      if (query.isEmpty) {
        return Result.success(SearchOrdersOutput(
          orders: [],
          totalCount: 0,
          searchQuery: query,
        ));
      }

      // Search orders
      final orders = await _orderRepository.search(input.shopId, query);

      // Convert to list items
      final orderItems = orders.map((o) => OrderListItem.fromOrder(o)).toList();

      // Sort by relevance (garment ID matches first, then by date)
      orderItems.sort((a, b) {
        final aGarmentMatch = a.garmentIdDisplay.toLowerCase().contains(query.toLowerCase());
        final bGarmentMatch = b.garmentIdDisplay.toLowerCase().contains(query.toLowerCase());
        
        if (aGarmentMatch && !bGarmentMatch) return -1;
        if (!aGarmentMatch && bGarmentMatch) return 1;
        
        return b.createdAt.compareTo(a.createdAt); // Most recent first
      });

      return Result.success(SearchOrdersOutput(
        orders: orderItems,
        totalCount: orderItems.length,
        searchQuery: query,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to search orders: $e',
        arabicMessage: 'فشل في البحث عن الطلبات',
      ));
    }
  }
}

