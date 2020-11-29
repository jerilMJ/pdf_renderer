import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pdf_page_state_provider/pdf_page_state_provider.dart';
import 'pdf_nav_slider.dart';

class ScrollbarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PDFPageStateProvider>(
      builder: (_, provider, __) {
        if (provider.totalPages == null) {
          return Container();
        } else {
          return Positioned(
            top: provider.swipeHorizontal ? null : 0.0,
            bottom: 0.0,
            right: 0.0,
            left: provider.swipeHorizontal ? 0.0 : null,
            child: FadeTransition(
              opacity: provider.navBarSlideAnimController,
              child: SlideTransition(
                position: provider.navBarAnim,
                child: RotatedBox(
                  quarterTurns: provider.swipeHorizontal ? 0 : 1,
                  child: ValueListenableBuilder(
                    valueListenable: provider.sliderVal,
                    builder: (_, val, __) => Listener(
                      onPointerDown: provider.sliderOnPointerDown,
                      onPointerUp: provider.sliderOnPointerUp,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbShape: PDFNavSliderThumbShape(
                              horizontal: provider.swipeHorizontal,
                              currentPage: provider.currentPage,
                              totalPages: provider.totalPages,
                            ),
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            activeTickMarkColor: Colors.transparent,
                            inactiveTickMarkColor: Colors.transparent,
                          ),
                          child: Slider(
                            divisions: provider.totalPages + 1,
                            value: val,
                            onChanged: provider.sliderOnChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
