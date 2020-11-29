part of 'pdf_page_state_provider.dart';

/// Mixin to be used for PDFViewStateProvider
abstract class PDFViewAnimations {
  factory PDFViewAnimations._() => null;

  AnimationController _appBarSlideAnimController;
  AnimationController _navBarSlideAnimController;
  Animation<Offset> appBarAnim;
  Animation<Offset> navBarAnim;
  Function onTapPDF;
  PDFNavState _latestPDFNavState;
  Timer _navHideTimer;
  // ignore: close_sinks
  StreamController _dragStream;

  void initAnimations(TickerProvider tickerProvider) {
    _appBarSlideAnimController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 250),
    );
    _navBarSlideAnimController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 250),
    );

    appBarAnim = Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(_appBarSlideAnimController);
    navBarAnim = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(_navBarSlideAnimController);

    onTapPDF = () {
      if (_appBarSlideAnimController.status == AnimationStatus.dismissed)
        _appBarSlideAnimController.forward();
      else if (_appBarSlideAnimController.status == AnimationStatus.completed)
        _appBarSlideAnimController.reverse();
    };
  }

  void listenToDrag() {
    _dragStream = StreamController()
      ..stream.listen((event) {
        if (_latestPDFNavState == PDFNavState.scrollbarHeld &&
            event != PDFNavState.scrollbarLetGo) return;

        _latestPDFNavState = event;
        switch (event) {
          case PDFNavState.dragging:
            _navHideTimer?.cancel();
            _navBarSlideAnimController.forward();
            _navHideTimer = Timer(const Duration(milliseconds: 3000), () {
              if (_navBarSlideAnimController.status ==
                  AnimationStatus.completed)
                _navBarSlideAnimController.reverse();
            });
            break;

          case PDFNavState.scrollbarHeld:
            _navHideTimer?.cancel();
            if (_navBarSlideAnimController.status ==
                AnimationStatus.dismissed) {
              _navBarSlideAnimController.forward();
            }
            break;

          case PDFNavState.dragEnded:
          case PDFNavState.scrollbarLetGo:
            _navHideTimer?.cancel();
            _navHideTimer = Timer(const Duration(milliseconds: 3000), () {
              _navBarSlideAnimController.reverse();
            });
            break;
        }
      });
  }
}
