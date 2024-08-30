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
      img.Image? image = await _imagePreProcessing();
      if (image != null) {
        String? cropBase64Image = await _encodeCropImageToBase64(image);
        String? fullBase64Image = await _encodeFullImageToBase64(image);
        di.Response response = await dio.post(
          "$apiUrl/question/solve",
          options: di.Options(contentType: "application/json"),
          data: {
            "id": widget.question.id,
            "image": fullBase64Image,
            "answer": cropBase64Image
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<img.Image?> _imagePreProcessing() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.rawRgba);

      if (byteData != null && _lassoBounds != null) {
        int width = image.width;
        int height = image.height;

        img.Image fullImage = img.Image.fromBytes(
          width,
          height,
          byteData.buffer.asUint8List(),
          format: img.Format.rgba,
        );

        // 빨간색 선을 제외한 새로운 이미지 생성
        img.Image imageWithoutRedLines = _removeRedLinesFromImage(fullImage);

        img.Image whiteBackground = img.Image(width, height);
        img.fill(whiteBackground, img.getColor(255, 255, 255));

        img.drawImage(whiteBackground, imageWithoutRedLines);

        return whiteBackground;
      }
    } catch (e) {
      print('Error encoding image to base64: $e');
    }
    return null;
  }

  Future<String> _encodeFullImageToBase64(img.Image whiteBackground) async {
    // 크롭할 영역의 좌표를 구합니다.
    int cropX = (_lassoBounds!.left).toInt();
    int cropY = (_lassoBounds!.top).toInt();
    int cropWidth = (_lassoBounds!.width).toInt();
    int cropHeight = (_lassoBounds!.height).toInt();

    // 크롭된 영역을 whiteBackground에서 지움 (흰색으로 덮어씌움)
    img.fillRect(whiteBackground, cropX, cropY, cropX + cropWidth,
        cropY + cropHeight, img.getColor(255, 255, 255, 255));

    // JPEG로 인코딩
    Uint8List jpegBytes = Uint8List.fromList(img.encodeJpg(whiteBackground));
    String base64String = base64Encode(jpegBytes);

    return base64String;
  }

  Future<String> _encodeCropImageToBase64(img.Image whiteBackground) async {
    // 크롭할 영역의 좌표를 구합니다.
    int cropX = (_lassoBounds!.left).toInt();
    int cropY = (_lassoBounds!.top).toInt();
    int cropWidth = (_lassoBounds!.width).toInt();
    int cropHeight = (_lassoBounds!.height).toInt();

    // 이미지 크롭
    img.Image croppedImage =
    img.copyCrop(whiteBackground, cropX, cropY, cropWidth, cropHeight);

    // JPEG로 인코딩
    Uint8List crop_jpegBytes = Uint8List.fromList(img.encodeJpg(croppedImage));
    String crop_base64String = base64Encode(crop_jpegBytes);

    return crop_base64String;
  }

  img.Image _removeRedLinesFromImage(img.Image originalImage) {
    for (int y = 0; y < originalImage.height; y++) {
      for (int x = 0; x < originalImage.width; x++) {
        int pixel = originalImage.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        // 빨간색 계열의 픽셀 제거 (정확한 빨간색으로만 제거)
        if (red != green && red != blue) {
          originalImage.setPixel(
              x, y, img.getColor(255, 255, 255, 0)); // 투명색으로 변경
        }
      }
    }
    return originalImage;
  }

  Rect? _lassoBounds;

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
            _lassoBounds = Rect.fromLTRB(minX, minY, maxX, maxY);
            return;
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
