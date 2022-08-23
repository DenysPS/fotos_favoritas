import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AdaptiveImage extends ImageProvider<AdaptiveImage> {
  final String id;
  final double width;
  final double height;

  AdaptiveImage({required this.id, required this.width, required this.height});

  @override
  ImageStreamCompleter load(AdaptiveImage key, DecoderCallback decode) {
    throw UnimplementedError();
  }

  @override
  Future<AdaptiveImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AdaptiveImage>(this);
  }
}
