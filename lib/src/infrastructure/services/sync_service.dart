import 'package:tailorhouse/src/core/network/network_info.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/order_local_datasource.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/customer_local_datasource.dart';
import 'package:tailorhouse/src/infrastructure/datasources/remote/order_remote_datasource.dart';
import 'package:tailorhouse/src/infrastructure/datasources/remote/customer_remote_datasource.dart';
import 'package:tailorhouse/src/infrastructure/datasources/remote/measurement_remote_datasource.dart';

/// Service for synchronizing local data with remote server
/// 
/// Implements offline-first sync strategy:
/// - Local data is always the source of truth
/// - Sync happens in background when connectivity is available
/// - Conflicts are resolved using last-write-wins or timestamp-based resolution
class SyncService {
  final NetworkInfo _networkInfo;
  final OrderLocalDataSource _orderLocal;
  final CustomerLocalDataSource _customerLocal;
  final OrderRemoteDataSource _orderRemote;
  final CustomerRemoteDataSource _customerRemote;
  final MeasurementRemoteDataSource _measurementRemote;

  SyncService({
    required NetworkInfo networkInfo,
    required OrderLocalDataSource orderLocal,
    required CustomerLocalDataSource customerLocal,
    required OrderRemoteDataSource orderRemote,
    required CustomerRemoteDataSource customerRemote,
    required MeasurementRemoteDataSource measurementRemote,
  })  : _networkInfo = networkInfo,
        _orderLocal = orderLocal,
        _customerLocal = customerLocal,
        _orderRemote = orderRemote,
        _customerRemote = customerRemote,
        _measurementRemote = measurementRemote;

  /// Perform full sync for a shop
  Future<SyncResult> syncShop(String shopId) async {
    if (!await _networkInfo.isConnected) {
      return SyncResult(
        success: false,
        message: 'No network connection',
        syncedOrders: 0,
        syncedCustomers: 0,
        syncedMeasurements: 0,
      );
    }

    try {
      // Sync customers first (orders depend on them)
      final customers = _customerLocal.getByShopId(shopId);
      await _customerRemote.syncCustomers(customers);

      // Sync orders
      final orders = _orderLocal.getByShopId(shopId);
      await _orderRemote.syncOrders(orders);

      // Sync measurements (extract from orders)
      final measurements = orders
          .where((o) => o.measurement != null)
          .map((o) => o.measurement!)
          .toList();
      if (measurements.isNotEmpty) {
        await _measurementRemote.syncMeasurements(measurements);
      }

      return SyncResult(
        success: true,
        message: 'Sync completed successfully',
        syncedOrders: orders.length,
        syncedCustomers: customers.length,
        syncedMeasurements: measurements.length,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Sync failed: ${e.toString()}',
        syncedOrders: 0,
        syncedCustomers: 0,
        syncedMeasurements: 0,
      );
    }
  }

  /// Sync only new/updated orders since last sync
  Future<SyncResult> syncIncremental(String shopId, DateTime since) async {
    if (!await _networkInfo.isConnected) {
      return SyncResult(
        success: false,
        message: 'No network connection',
        syncedOrders: 0,
        syncedCustomers: 0,
        syncedMeasurements: 0,
      );
    }

    try {
      // Get orders updated since last sync
      final allOrders = _orderLocal.getByShopId(shopId);
      final ordersToSync = allOrders
          .where((o) => o.updatedAt.isAfter(since))
          .toList();

      if (ordersToSync.isEmpty) {
        return SyncResult(
          success: true,
          message: 'No changes to sync',
          syncedOrders: 0,
          syncedCustomers: 0,
          syncedMeasurements: 0,
        );
      }

      await _orderRemote.syncOrders(ordersToSync);

      return SyncResult(
        success: true,
        message: 'Incremental sync completed',
        syncedOrders: ordersToSync.length,
        syncedCustomers: 0,
        syncedMeasurements: 0,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Sync failed: ${e.toString()}',
        syncedOrders: 0,
        syncedCustomers: 0,
        syncedMeasurements: 0,
      );
    }
  }

  /// Pull latest data from server (for conflict resolution)
  Future<void> pullLatest(String shopId) async {
    if (!await _networkInfo.isConnected) return;

    try {
      // Pull latest orders
      final remoteOrders = await _orderRemote.getByShopId(shopId);
      for (final order in remoteOrders) {
        final local = _orderLocal.getById(order.id);
        if (local == null || order.updatedAt.isAfter(local.updatedAt)) {
          await _orderLocal.save(order);
        }
      }
    } catch (e) {
      // Log error but don't throw - offline-first means local is primary
    }
  }
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String message;
  final int syncedOrders;
  final int syncedCustomers;
  final int syncedMeasurements;

  SyncResult({
    required this.success,
    required this.message,
    required this.syncedOrders,
    required this.syncedCustomers,
    required this.syncedMeasurements,
  });
}

