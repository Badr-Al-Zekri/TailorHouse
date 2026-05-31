import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';


/// AI Measurement Screen
/// 
/// Per PRD FR-3, FR-4: Capture front/side/back images and extract measurements
/// Guides user through photo capture process
class AiMeasurementScreen extends StatefulWidget {
  final String orderId;

  const AiMeasurementScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<AiMeasurementScreen> createState() => _AiMeasurementScreenState();
}

class _AiMeasurementScreenState extends State<AiMeasurementScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _currentStep = 0; // 0: front, 1: side, 2: back
  final List<String> _capturedImages = [];
  bool _isInitialized = false;
  final String _currentUserId = 'USER_001'; // TODO: Get from current user

  final List<_PhotoStep> _steps = [
    _PhotoStep(
      title: 'التقاط صورة أمامية',
      description: 'قف بشكل مستقيم ووجه الكاميرا للأمام',
      icon: Icons.camera_front,
    ),
    _PhotoStep(
      title: 'التقاط صورة جانبية',
      description: 'قف بشكل جانبي ووجه الكاميرا للجانب',
      icon: Icons.camera_alt,
    ),
    _PhotoStep(
      title: 'التقاط صورة خلفية',
      description: 'قف بشكل مستقيم ووجه الكاميرا للخلف',
      icon: Icons.camera_rear,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تهيئة الكاميرا: $e')),
        );
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImages.add(image.path);
        if (_currentStep < _steps.length - 1) {
          _currentStep++;
        }
      });

      if (_currentStep >= _steps.length - 1) {
        // All photos captured, process measurements
        _processMeasurements();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في التقاط الصورة: $e')),
        );
      }
    }
  }

  void _processMeasurements() {
    // TODO: Integrate with AI measurement service
    // For now, show results screen with placeholder data
    context.push(
      '${AppRoutes.measurementResults}?orderId=${widget.orderId}',
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القياس بالذكاء الاصطناعي', style: AppTypography.titleLarge),
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: List.generate(
                      _steps.length,
                      (index) => Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(
                            right: index < _steps.length - 1 ? 4 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? AppColors.primary
                                : AppColors.textSecondary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Current step info
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Icon(
                        _steps[_currentStep].icon,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _steps[_currentStep].title,
                        style: AppTypography.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _steps[_currentStep].description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Camera preview
                Expanded(
                  child: _cameraController != null &&
                          _cameraController!.value.isInitialized
                      ? CameraPreview(_cameraController!)
                      : const Center(child: CircularProgressIndicator()),
                ),
                // Capture button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppButton.primary(
                    text: _currentStep < _steps.length - 1
                        ? 'التقاط الصورة'
                        : 'إنهاء القياس',
                    onPressed: _capturePhoto,
                    leadingIcon: Icons.camera_alt,
                  ),
                ),
              ],
            ),
    );
  }
}

class _PhotoStep {
  final String title;
  final String description;
  final IconData icon;

  _PhotoStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
