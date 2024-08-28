import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dalgeurak/data/Question.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart' as di;

class DrawingScreen extends StatefulWidget {
  final Question question;

  const DrawingScreen({Key? key, required this.question}) : super(key: key);

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<Offset?> _points = [];
  Offset? _lastPosition;
  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.question.id}번 문제'),
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 상단에 위치한 이미지
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.network(
                      '$apiUrl/save/${widget.question.name}', // 이미지 URL
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('이미지를 불러오는 데 실패했습니다.'),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // 그림판을 그릴 공간
              Positioned.fill(
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: Stack(
                    children: [
                      Listener(
                        onPointerMove: (event) {
                          setState(() {
                            RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                            Offset localPosition =
                            renderBox.globalToLocal(event.position);
                            if (_lastPosition != null &&
                                (localPosition - _lastPosition!).distance > 1.0) {
                              _points.add(localPosition);
                            }
                            _lastPosition = localPosition;
                          });
                        },
                        onPointerUp: (event) {
                          setState(() {
                            _points.add(null);
                            _lastPosition = null;
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(_points),
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 제출 버튼
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () async {
                    // 이미지 저장 호출
                    await _sendDrawing();
                  },
                  child: const Text('제출'),
                ),
              ),
              // Undo 버튼
              Positioned(
                bottom: 16,
                left: 16,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _undo();
                    });
                  },
                  child: const Text('Undo'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Undo 메서드
  void _undo() {
    if (_points.isNotEmpty) {
      _points.removeLast();
      setState(() {});
    }
  }

  Future<void> _sendDrawing() async {
    try {
      String? base64Image = await encodeImageToBase64();
      if (base64Image != null) {
        di.Response response = await dio.post(
          "$apiUrl/question/solve",
          options: di.Options(contentType: "application/json"),
          data: {"id": widget.question.id, "image": base64Image},
        );
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // 그린 그림을 JPEG로 저장
  Future<String?> encodeImageToBase64() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

      if (byteData != null) {
        // Get image dimensions
        int width = image.width;
        int height = image.height;

        // Create a white background image
        img.Image whiteBackground = img.Image(width, height);
        img.fill(whiteBackground, img.getColor(255, 255, 255)); // Fill with white color

        // Convert ui.Image to img.Image
        Uint8List rgbaBytes = byteData.buffer.asUint8List();
        img.Image drawingImage = img.Image.fromBytes(width, height, rgbaBytes, format: img.Format.rgba);

        // Composite images: white background and drawing
        img.drawImage(whiteBackground, drawingImage);

        // Encode final image as JPEG
        Uint8List jpegBytes = Uint8List.fromList(img.encodeJpg(whiteBackground));
        String base64String = base64Encode(jpegBytes);

        return base64String;
      }
    } catch (e) {
      print('Error encoding image to base64: $e');
    }
    return null;
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
