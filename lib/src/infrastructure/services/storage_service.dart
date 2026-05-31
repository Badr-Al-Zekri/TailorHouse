import 'package:hive_flutter/hive_flutter.dart';
import 'package:tailorhouse/src/infrastructure/models/shop_model.dart';
import 'package:tailorhouse/src/infrastructure/models/customer_model.dart';
import 'package:tailorhouse/src/infrastructure/models/measurement_model.dart';
import 'package:tailorhouse/src/infrastructure/models/workflow_log_model.dart';
import 'package:tailorhouse/src/infrastructure/models/order_model.dart';
import 'package:tailorhouse/src/infrastructure/models/user_model.dart';

/// Storage service for initializing and managing local storage
/// 
/// Uses Hive for offline-first data persistence.
class StorageService {
  static const String _shopsBox = 'shops';
  static const String _customersBox = 'customers';
  static const String _measurementsBox = 'measurements';
  static const String _workflowLogsBox = 'workflow_logs';
  static const String _ordersBox = 'orders';
  static const String _usersBox = 'users';
  static const String _settingsBox = 'settings';
  static const String _sequencesBox = 'sequences';

  static const String _currentShopKey = 'current_shop_id';

  bool _isInitialized = false;

  /// Initialize Hive and register adapters
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    _registerAdapters();

    // Open boxes
    await _openBoxes();

    _isInitialized = true;
  }

  void _registerAdapters() {
    // Shop
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ShopModelAdapter());
    }

    // Customer
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CustomerModelAdapter());
    }

    // MeasurementValue
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MeasurementValueModelAdapter());
    }

    // Measurement
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(MeasurementModelAdapter());
    }

    // WorkflowLog
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WorkflowLogModelAdapter());
    }

    // Order
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(OrderModelAdapter());
    }

    // User
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(UserModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<ShopModel>(_shopsBox);
    await Hive.openBox<CustomerModel>(_customersBox);
    await Hive.openBox<MeasurementModel>(_measurementsBox);
    await Hive.openBox<WorkflowLogModel>(_workflowLogsBox);
    await Hive.openBox<OrderModel>(_ordersBox);
    await Hive.openBox<UserModel>(_usersBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox<int>(_sequencesBox);
  }

  /// Get shops box
  Box<ShopModel> get shopsBox => Hive.box<ShopModel>(_shopsBox);

  /// Get customers box
  Box<CustomerModel> get customersBox => Hive.box<CustomerModel>(_customersBox);

  /// Get measurements box
  Box<MeasurementModel> get measurementsBox =>
      Hive.box<MeasurementModel>(_measurementsBox);

  /// Get workflow logs box
  Box<WorkflowLogModel> get workflowLogsBox =>
      Hive.box<WorkflowLogModel>(_workflowLogsBox);

  /// Get orders box
  Box<OrderModel> get ordersBox => Hive.box<OrderModel>(_ordersBox);

  /// Get users box
  Box<UserModel> get usersBox => Hive.box<UserModel>(_usersBox);

  /// Get settings box
  Box get settingsBox => Hive.box(_settingsBox);

  /// Get sequences box (for garment ID generation)
  Box<int> get sequencesBox => Hive.box<int>(_sequencesBox);

  /// Get current shop ID
  String? get currentShopId => settingsBox.get(_currentShopKey) as String?;

  /// Set current shop ID
  Future<void> setCurrentShopId(String shopId) async {
    await settingsBox.put(_currentShopKey, shopId);
  }

  /// Generate sequence key for garment ID
  String sequenceKey(String shopCode, int year) => '${shopCode}_$year';

  /// Get last sequence for shop/year
  int getLastSequence(String shopCode, int year) {
    return sequencesBox.get(sequenceKey(shopCode, year)) ?? 0;
  }

  /// Set sequence for shop/year
  Future<void> setSequence(String shopCode, int year, int sequence) async {
    await sequencesBox.put(sequenceKey(shopCode, year), sequence);
  }

  /// Clear all data (for testing or reset)
  Future<void> clearAll() async {
    await shopsBox.clear();
    await customersBox.clear();
    await measurementsBox.clear();
    await workflowLogsBox.clear();
    await ordersBox.clear();
    await usersBox.clear();
    await settingsBox.clear();
    await sequencesBox.clear();
  }

  /// Close all boxes
  Future<void> close() async {
    await Hive.close();
    _isInitialized = false;
  }
}

