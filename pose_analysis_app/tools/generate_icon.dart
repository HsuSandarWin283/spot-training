import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IconGenerator {
  static Future<void> generate() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1024, 1024));

    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(1024, 1024),
        [const Color(0xFF6C63FF), const Color(0xFF00D4AA)],
      );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 1024, 1024),
        const Radius.circular(200),
      ),
      bgPaint,
    );

    final circlePaint = Paint()..color = Colors.white.withOpacity(0.12);
    canvas.drawCircle(const Offset(512, 440), 300, circlePaint);

    final bodyPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final head = Offset(512, 260);
    final neck = Offset(512, 330);
    final lShoulder = Offset(410, 380);
    final rShoulder = Offset(614, 380);
    final lElbow = Offset(330, 490);
    final rElbow = Offset(694, 490);
    final lWrist = Offset(360, 580);
    final rWrist = Offset(664, 580);
    final hip = Offset(512, 530);
    final lKnee = Offset(430, 670);
    final rKnee = Offset(594, 670);
    final lAnkle = Offset(410, 800);
    final rAnkle = Offset(614, 800);

    final connections = [
      [head, neck], [neck, lShoulder], [neck, rShoulder],
      [lShoulder, lElbow], [rShoulder, rElbow],
      [lElbow, lWrist], [rElbow, rWrist],
      [neck, hip], [hip, lKnee], [hip, rKnee],
      [lKnee, lAnkle], [rKnee, rAnkle],
    ];

    for (final c in connections) {
      canvas.drawLine(c[0], c[1], bodyPaint);
    }

    final points = [
      head, neck, lShoulder, rShoulder, lElbow, rElbow,
      lWrist, rWrist, hip, lKnee, rKnee, lAnkle, rAnkle,
    ];
    for (final p in points) {
      canvas.drawCircle(p, 14, dotPaint);
      canvas.drawCircle(p, 14, Paint()
        ..color = const Color(0xFF6C63FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(1024, 1024);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final iconFile = File('assets/icon/app_icon.png');
    await iconFile.create(recursive: true);
    await iconFile.writeAsBytes(bytes);

    final sizes = {
      'mipmap-mdpi': 48,
      'mipmap-hdpi': 72,
      'mipmap-xhdpi': 96,
      'mipmap-xxhdpi': 144,
      'mipmap-xxxhdpi': 192,
    };

    for (final entry in sizes.entries) {
      final dir = Directory('android/app/src/main/res/${entry.key}');
      if (dir.existsSync()) {
        final resized = await _resize(bytes, entry.value);
        await File('${dir.path}/ic_launcher.png').writeAsBytes(resized);
        await File('${dir.path}/ic_launcher_round.png').writeAsBytes(resized);
      }
    }

    print('App icon generated successfully!');
    image.dispose();
  }

  static Future<Uint8List> _resize(Uint8List src, int size) async {
    final codec = await ui.instantiateImageCodec(src);
    final frame = await codec.getNextFrame();
    final img = frame.image;

    final r = ui.PictureRecorder();
    final c = Canvas(r, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));
    c.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      Paint()..filterQuality = FilterQuality.high,
    );

    final pic = r.endRecording();
    final out = await pic.toImage(size, size);
    final bd = await out.toByteData(format: ui.ImageByteFormat.png);
    img.dispose();
    out.dispose();
    return bd!.buffer.asUint8List();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IconGenerator.generate();
  // ignore: avoid_print
}
