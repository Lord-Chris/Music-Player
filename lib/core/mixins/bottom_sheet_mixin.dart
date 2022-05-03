import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/playing/playing.dart';

mixin BottomSheetMixin {
  final _key = NavigationService.navigatorKey;

  Future<T?> showPlayingBottomSheet<T>(
      {required Track track, bool shouldPlay = true}) {
    return showModalBottomSheet(
      context: _key.currentContext!,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return Playing(
          song: track,
          startPlaying: shouldPlay,
        );
      },
    );
  }
}
