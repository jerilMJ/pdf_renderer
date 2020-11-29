import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PDFNavSliderThumbShape extends SliderComponentShape {
  PDFNavSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.currentPage,
    this.totalPages,
    @required this.horizontal,
  });

  final bool horizontal;
  final double enabledThumbRadius;
  final double disabledThumbRadius;

  final int currentPage;
  final int totalPages;

  final Size _thumbSize = Size(40.0, 35.0);
  final double _paraWidth = 60.0;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    _drawThumb(canvas, center, colorTween, enableAnimation);
    _drawThumbDecor(canvas, center);
  }

  void _drawThumb(Canvas canvas, Offset center, ColorTween colorTween,
      Animation<double> enableAnimation) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: center,
          width: _thumbSize.width,
          height: _thumbSize.height,
        ),
        topLeft: horizontal ? Radius.circular(1000.0) : Radius.zero,
        topRight: horizontal ? Radius.circular(1000.0) : Radius.zero,
        bottomLeft: horizontal ? Radius.zero : Radius.circular(1000.0),
        bottomRight: horizontal ? Radius.zero : Radius.circular(1000.0),
      ),
      Paint()..color = colorTween.evaluate(enableAnimation),
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
            center.dx,
            horizontal
                ? center.dy + _thumbSize.width / 2
                : center.dy - _thumbSize.width / 2),
        width: _thumbSize.width,
        height: _thumbSize.height,
      ),
      Paint()..color = colorTween.evaluate(enableAnimation),
    );
  }

  void _drawThumbDecor(
    ui.Canvas canvas,
    ui.Offset center,
  ) {
    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textDirection: ui.TextDirection.ltr,
        textAlign: horizontal ? TextAlign.center : TextAlign.end,
      ),
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText('${(currentPage + 1)} / $totalPages');
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: _paraWidth));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi / 2);
    canvas.translate(-center.dx, -center.dy);

    final icon = Icons.drag_handle;
    var builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontFamily: icon.fontFamily,
        fontSize: 32.0,
      ),
    )..addText(String.fromCharCode(icon.codePoint));
    var para = builder.build();
    para.layout(ui.ParagraphConstraints(width: _paraWidth));
    canvas.drawParagraph(
        para,
        Offset(horizontal ? center.dx - 20.0 : center.dx - 10.0,
            center.dy - 16.0));

    canvas.restore();

    if (!horizontal) {
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-pi / 2);
      canvas.translate(-center.dx, -center.dy);
    }

    if (horizontal) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy - (_thumbSize.width + 5.0)),
            width: -paragraph.longestLine - 20.0,
            height: 2 * paragraph.height,
          ),
          Radius.circular(10.0),
        ),
        Paint()..color = Colors.grey.shade300,
      );
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            center.dx - 50.0 - paragraph.longestLine,
            center.dy - paragraph.height,
            center.dx - (_paraWidth / 2),
            center.dy + paragraph.height,
          ),
          Radius.circular(10.0),
        ),
        Paint()..color = Colors.grey.shade300,
      );
    }
    canvas.drawParagraph(
      paragraph,
      Offset(
        horizontal ? center.dx - (_paraWidth / 2) : center.dx - 100.0,
        horizontal ? center.dy - 54.0 : center.dy - 8.0,
      ),
    );
  }
}
