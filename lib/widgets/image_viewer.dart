// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:custom_full_image_screen/custom_full_image_screen.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key? key,
    required this.urlDownload,
  }) : super(key: key);

  final String urlDownload;

  @override
  Widget build(BuildContext context) {
    return ImageCachedFullscreen(
      imageUrl: urlDownload,
      imageBorderRadius: 300,
      imageWidth: 150,
      imageHeight: 150,
      imageDetailsHeight: 500,
      imageDetailsWidth: MediaQuery.of(context).size.width,
      // iconBackButtonColor: kGreenShadeColor,
      // hideBackButtonDetails: false,
      backgroundColorDetails: kBlueShadeColor,
      imageDetailsFit: BoxFit.cover,
      // hideAppBarDetails: true,
      imageFit: BoxFit.fill,
      withHeroAnimation: false,
      placeholderDetails: CircularProgressIndicator(),
      placeholder: CircularProgressIndicator(),
      errorWidget: Text(
        'Image corrupted',
        style: TextStyle(color: kGreenShadeColor),
      ),
    );
  }
}
