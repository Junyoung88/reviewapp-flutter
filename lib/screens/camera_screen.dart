import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../utils/page_transitions.dart';
import '../widgets/premium_loading_indicator.dart';
import '../widgets/water_drop_button.dart';
import 'loading_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;

  late final AnimationController _captureAnimController;
  late final Animation<double> _captureScaleAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _captureAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _captureScaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 40,
      ),
    ]).animate(_captureAnimController);

    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          Navigator.of(context).pop('사용 가능한 카메라가 없습니다');
        }
        return;
      }

      await _setupController(_cameras![_selectedCameraIndex]);
    } on CameraException catch (e) {
      if (!mounted) return;
      if (e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt') {
        _showPermissionDeniedDialog();
      } else {
        Navigator.of(context).pop('카메라를 초기화할 수 없습니다');
      }
    }
  }

  Future<void> _setupController(CameraDescription camera) async {
    _controller?.dispose();
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    await _controller!.setFlashMode(_flashMode);

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('카메라 권한 필요'),
        content: const Text('상품 촬영을 위해 카메라 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _onCaptureTap() async {
    if (_isCapturing || !_isInitialized || _controller == null) return;
    setState(() => _isCapturing = true);

    try {
      // Animation + capture in parallel
      final animFuture = _captureAnimController.forward();
      final captureFuture = _controller!.takePicture();

      await animFuture;
      final photo = await captureFuture;
      _captureAnimController.reset();

      if (!mounted) return;

      final imageFile = File(photo.path);

      final errorMessage = await Navigator.of(context).push<String>(
        SlideUpFadeRoute(page: LoadingScreen(imageFile: imageFile)),
      );

      // If error returned from LoadingScreen, propagate to HomeScreen
      if (errorMessage != null && mounted) {
        Navigator.of(context).pop(errorMessage);
        return;
      }
    } catch (e) {
      _captureAnimController.reset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('촬영 실패: $e'),
            backgroundColor: AppColors.consRed,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    final next =
        _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await _controller!.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    setState(() => _isInitialized = false);
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    await _setupController(_cameras![_selectedCameraIndex]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
      setState(() => _isInitialized = false);
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _captureAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    '카메라',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, curve: Curves.easeOutCubic),

            const Spacer(),

            // Camera preview card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildCameraPreview(),
            )
                .animate()
                .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.0, 1.0),
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 32),

            // Controls
            _buildControlRow()
                .animate()
                .fadeIn(
                    duration: 400.ms,
                    delay: 200.ms,
                    curve: Curves.easeOutCubic)
                .slideY(
                  begin: 0.15,
                  end: 0,
                  duration: 400.ms,
                  delay: 200.ms,
                  curve: Curves.easeOutCubic,
                ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStart.withAlpha(20),
            AppColors.gradientEnd.withAlpha(20),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: _isInitialized && _controller != null
              ? CameraPreview(_controller!)
              : Container(
                  color: AppColors.shimmerBase,
                  child: const Center(
                    child: PremiumLoadingIndicator(size: 40),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildControlRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flash toggle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                _flashMode == FlashMode.off
                    ? Icons.flash_off_rounded
                    : Icons.flash_on_rounded,
                color: _flashMode == FlashMode.off
                    ? AppColors.textSecondary
                    : AppColors.primaryBlue,
                size: 22,
              ),
            ),
          ),

          // Capture button with bounce animation
          AnimatedBuilder(
            animation: _captureScaleAnim,
            builder: (context, child) => Transform.scale(
              scale: _captureScaleAnim.value,
              child: child,
            ),
            child: WaterDropButton(onTap: _onCaptureTap, size: 72),
          ),

          // Camera flip
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: IconButton(
              onPressed: _flipCamera,
              icon: const Icon(
                Icons.cameraswitch_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
