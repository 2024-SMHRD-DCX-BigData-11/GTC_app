import 'package:flutter/material.dart';
import 'package:dalgeurak/data/Question.dart';
import 'package:dalgeurak/plugins/dimigoin_flutter_plugin/lib/dimigoin_flutter_plugin.dart';

class DrawingScreen extends StatefulWidget {
  final Question question;

  const DrawingScreen({Key? key, required this.question}) : super(key: key);

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<Offset?> _points = [];
  late Size _imageSize;

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
                // height: constraints.maxHeight * 0.5, // 이미지의 높이를 화면의 절반으로 설정
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
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('이미지를 불러오는 데 실패했습니다.'));
                      },
                    ),
                  ),
                ),
              ),
              // 그림판을 그릴 공간
              Positioned.fill(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                      _points.add(localPosition);
                    });
                  },
                  onPanEnd: (details) {
                    _points.add(null);
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(_points),
                    child: Container(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
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
