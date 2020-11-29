part of 'pdf_page_state_provider.dart';

/// Mixin to be used for PDFViewStateProvider
abstract class PDFPageAccessibilityOptions {
  factory PDFPageAccessibilityOptions._() => null;

  bool swipeHorizontal = true;
  bool autoSpacing = true;
  bool pageFling = true;
  bool nightMode = false;

  bool executeOption(
      PDFViewerOption option, BuildContext context, int currentPage) {
    bool shouldSetState = true;

    switch (option) {
      case PDFViewerOption.organizeHorizontal:
        organizePagesHorizontal();
        break;

      case PDFViewerOption.organizeVertical:
        organizePagesVertically();
        break;

      case PDFViewerOption.condensePages:
        condensePages();
        break;

      case PDFViewerOption.expandPages:
        expandPages();
        break;

      case PDFViewerOption.scrollContinuous:
        setContinuousScroll();
        break;

      case PDFViewerOption.scrollPageByPage:
        setPageByPageScroll();
        break;

      case PDFViewerOption.toggleBookmark:
        shouldSetState = false;
        if (BlocProvider.of<PDFPageBloc>(context).isBookmarked(currentPage))
          PDFPage.of(context)
              .buildRemoveBookmarkDialog(context, Bookmark(page: currentPage));
        else
          PDFPage.of(context).buildBookmarkBottomSheet(context, currentPage);
        break;

      case PDFViewerOption.manageBookmarks:
        shouldSetState = false;
        PDFPage.of(context).buildBookmarkManager(context);
        break;

      case PDFViewerOption.nightMode:
        setNightTheme();
        break;

      case PDFViewerOption.lightMode:
        setLightTheme();
        break;

      default:
        break;
    }

    return shouldSetState;
  }

  void organizePagesHorizontal() {
    swipeHorizontal = true;
  }

  void organizePagesVertically() {
    swipeHorizontal = false;
  }

  void condensePages() {
    autoSpacing = false;
  }

  void expandPages() {
    autoSpacing = true;
  }

  void setContinuousScroll() {
    pageFling = false;
  }

  void setPageByPageScroll() {
    pageFling = true;
  }

  void setNightTheme() {
    nightMode = true;
  }

  void setLightTheme() {
    nightMode = false;
  }
}
