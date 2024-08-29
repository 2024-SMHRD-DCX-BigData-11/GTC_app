import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dalgeurak/data/question.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart' as di;

class DrawingScreen extends StatefulWidget {
  final Question question;

  const DrawingScreen({Key? key, required this.question}) : super(key: key);

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<DrawnLine> _lines = []; // 그려진 선을 저장하는 리스트
  final GlobalKey _repaintKey = GlobalKey();
  bool _isEraserMode = false; // 지우개 모드 여부를 나타내는 상태 변수
  bool _isRedPenMode = false; // 빨간 펜 모드 여부를 나타내는 상태 변수
  DrawnLine? _currentLine; // 현재 그리는 선

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
              Positioned.fill(
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: Listener(
                    onPointerDown: (event) {
                      setState(() {
                        if (_isEraserMode) {
                          // 지우개 모드에서는 선을 지움
                          _eraseLine(event.localPosition);
                        } else {
                          // 새로운 빨간 펜 라인을 그리기 전에 기존 빨간 펜 라인을 삭제
                          if (_isRedPenMode) {
                            _removeRedLines();
                          }
                          // 그리기 모드에서는 새로운 선을 그림
                          _currentLine = DrawnLine(
                            points: [event.localPosition],
                            color: _isRedPenMode ? Colors.red : Colors.black,
                            strokeWidth: 5.0,
                          );
                          _lines.add(_currentLine!);
                        }
                      });
                    },
                    onPointerMove: (event) {
                      setState(() {
                        if (!_isEraserMode && _currentLine != null) {
                          _currentLine!.points.add(event.localPosition);
                        } else if (_isEraserMode) {
                          _eraseLine(event.localPosition);
                        }
                      });
                    },
                    onPointerUp: (event) {
                      setState(() {
                        _currentLine = null;
                        if (_isRedPenMode) {
                          _detectCircle(); // 동그라미 인식 로직 추가
                        }
                      });
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(_lines),
                      child: Container(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () async {
                    await _sendDrawing();
                    Get.back();
                    showToast("답안 제출이 완료되었습니다.");
                  },
                  child: const Text('제출'),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _undo();
                    });
                  },
                  child: const Text('되돌리기'),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 116,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEraserMode = !_isEraserMode;
                    });
                  },
                  child: Text(_isEraserMode ? '펜 모드' : '지우개 모드'),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 216,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRedPenMode = !_isRedPenMode;
                    });
                  },
                  child: Text(_isRedPenMode ? '검정 펜' : '빨간 펜'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _removeRedLines() {
    _lines.removeWhere((line) => line.color == Colors.red);
  }

  void _undo() {
    if (_lines.isNotEmpty) {
      _lines.removeLast();
      setState(() {});
    }
  }

  void _eraseLine(Offset position) {
    setState(() {
      _lines.removeWhere((line) => line.points.any((point) {
        return (point - position).distance <= 20.0; // 선의 두께나 범위에 따라 조정 가능
      }));
    });
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

  Future<String?> encodeImageToBase64() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage();
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);

      if (byteData != null) {
        int width = image.width;
        int height = image.height;

        img.Image whiteBackground = img.Image(width, height);
        img.fill(whiteBackground, img.getColor(255, 255, 255));

        Uint8List rgbaBytes = byteData.buffer.asUint8List();
        img.Image drawingImage = img.Image.fromBytes(width, height, rgbaBytes,
            format: img.Format.rgba);

        img.drawImage(whiteBackground, drawingImage);

        Uint8List jpegBytes =
        Uint8List.fromList(img.encodeJpg(whiteBackground));
        String base64String = base64Encode(jpegBytes);

        return base64String;
      }
    } catch (e) {
      print('Error encoding image to base64: $e');
    }
    return null;
  }

  // 동그라미 인식 로직 추가
  void _detectCircle() {
    double minLassoRadius = 20.0; // 올가미로 인식하는 최소 반지름
    double maxAllowedGap = 30.0; // 올가미가 감싸는 선 사이의 최대 허용 간격

    for (var line in _lines) {
      if (line.color == Colors.red && line.points.isNotEmpty) {
        double minX =
        line.points.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
        double maxX =
        line.points.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
        double minY =
        line.points.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
        double maxY =
        line.points.map((p) => p.dy).reduce((a, b) => a > b ? a : b);

        double width = maxX - minX;
        double height = maxY - minY;

        // 올가미의 최소 크기를 충족하는지 확인
        if (width >= minLassoRadius * 2 && height >= minLassoRadius * 2) {
          bool isLasso = true;

          // 모든 점 사이의 거리가 특정 임계값 이하인지 확인
          for (int i = 0; i < line.points.length - 1; i++) {
            if ((line.points[i] - line.points[i + 1]).distance >
                maxAllowedGap) {
              isLasso = false;
              break;
            }
          }

          if (isLasso) {
            showToast("올가미가 인식되었습니다!");
          }
        }
      }
    }
  }
}

class DrawnLine {
  List<Offset> points;
  Color color;
  double strokeWidth;

  DrawnLine({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawnLine> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.strokeWidth;

      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != null && line.points[i + 1] != null) {
          canvas.drawLine(line.points[i], line.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
