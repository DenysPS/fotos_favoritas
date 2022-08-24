import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class AdaptiveImage extends ImageProvider<AdaptiveImage> {
  final String id;
  final double width;
  final double height;

  AdaptiveImage({required this.id, required this.width, required this.height});

  @override
  ImageStreamCompleter load(AdaptiveImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: id,
      informationCollector: () sync* {
        yield ErrorDescription('Id: $id');
      },
    );
  }

  @override
  Future<AdaptiveImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AdaptiveImage>(this);
  }

  Future<Codec> _loadAsync(AdaptiveImage key, DecoderCallback decode) async {
    assert(key == this);

    final bytes = await methodChannel.invokeMethod<Uint8List>(
      'fetchImage',
      {'id': id, 'width': width, 'height': height},
    );

    if (bytes == null || bytes.lengthInBytes == 0) {
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError("A image $id não pôde ser carregada!");
    }
    return decode(bytes);
  }
}
