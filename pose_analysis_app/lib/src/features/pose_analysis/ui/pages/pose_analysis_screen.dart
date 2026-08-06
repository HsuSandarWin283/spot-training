// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ai_sports_training/src/core/theme/app_theme.dart';
import 'package:ai_sports_training/src/core/widgets/app_widgets.dart';
import 'package:ai_sports_training/src/core/l10n/app_localizations.dart';
import 'package:ai_sports_training/src/core/utils/app_router.dart';

class PoseAnalysisScreen extends StatefulWidget {
  const PoseAnalysisScreen({super.key});

  @override
  State<PoseAnalysisScreen> createState() => _PoseAnalysisScreenState();
}

class _PoseAnalysisScreenState extends State<PoseAnalysisScreen> {
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          SafeArea(
            child: Column(
              children: [
                CustomAppBar(title: AppLocalizations.of(context)!.poseAnalysisTitle, showBack: false),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.crd(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: AppColors.crd(context),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.videocam,
                                        size: 60,
                                        color: AppColors.txtMuted(context),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        AppLocalizations.of(context)!.cameraPreview,
                                        style: TextStyle(
                                          color: AppColors.txtMuted(context),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              CustomPaint(
                                painter: _SkeletonPainter(),
                                size: Size.infinite,
                              ),
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        AppLocalizations.of(context)!.live,
                                        style: TextStyle(
                                          color: AppColors.success,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Score: 87%',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.crd(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.bdr(context)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('⚖️', AppLocalizations.of(context)!.bodyBalance, '92%'),
                      _buildVerticalDivider(),
                      _buildMetric('🦵', AppLocalizations.of(context)!.kneeAngle, '135°'),
                      _buildVerticalDivider(),
                      _buildMetric('🦶', AppLocalizations.of(context)!.legPosition, 'Good'),
                      _buildVerticalDivider(),
                      _buildMetric('➡️', AppLocalizations.of(context)!.followThrough, '85%'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: GradientButton(
                    text: _isAnalyzing ? AppLocalizations.of(context)!.analyzing : AppLocalizations.of(context)!.startAnalysis,
                    icon: _isAnalyzing ? null : Icons.play_arrow,
                    onPressed: _isAnalyzing
                        ? () {}
                        : () {
                            setState(() => _isAnalyzing = true);
                            Future.delayed(const Duration(seconds: 3), () {
                              if (mounted) {
                                setState(() => _isAnalyzing = false);
                                context.goToPoseFeedback();
                              }
                            });
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.txtPrimary(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.txtMuted(context),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.bdr(context),
    );
  }
}

class _SkeletonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final head = Offset(cx, cy - 80);
    final neck = Offset(cx, cy - 60);
    final leftShoulder = Offset(cx - 40, cy - 45);
    final rightShoulder = Offset(cx + 40, cy - 45);
    final leftElbow = Offset(cx - 65, cy - 15);
    final rightElbow = Offset(cx + 65, cy - 15);
    final leftWrist = Offset(cx - 55, cy + 20);
    final rightWrist = Offset(cx + 55, cy + 20);
    final hip = Offset(cx, cy + 10);
    final leftKnee = Offset(cx - 25, cy + 60);
    final rightKnee = Offset(cx + 25, cy + 60);
    final leftAnkle = Offset(cx - 25, cy + 110);
    final rightAnkle = Offset(cx + 25, cy + 110);

    final connections = [
      [head, neck],
      [neck, leftShoulder],
      [neck, rightShoulder],
      [leftShoulder, leftElbow],
      [rightShoulder, rightElbow],
      [leftElbow, leftWrist],
      [rightElbow, rightWrist],
      [neck, hip],
      [hip, leftKnee],
      [hip, rightKnee],
      [leftKnee, leftAnkle],
      [rightKnee, rightAnkle],
    ];

    for (final connection in connections) {
      canvas.drawLine(connection[0], connection[1], paint);
    }

    final points = [
      head, neck, leftShoulder, rightShoulder,
      leftElbow, rightElbow, leftWrist, rightWrist,
      hip, leftKnee, rightKnee, leftAnkle, rightAnkle,
    ];

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 5, Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
