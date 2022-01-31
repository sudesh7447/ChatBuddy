// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:custom_full_image_screen/custom_full_image_screen.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    Key? key,
    required this.urlDownload,
    this.width = 150,
    this.height = 150,
    required this.finalWidth,
    required this.finalHeight,
  }) : super(key: key);

  final String urlDownload;
  final double width, height;
  final double finalHeight, finalWidth;

  @override
  Widget build(BuildContext context) {
    return ImageCachedFullscreen(
      imageUrl: urlDownload,
      imageBorderRadius: 300,
      imageWidth: width,
      imageHeight: height,
      imageDetailsHeight: finalHeight,
      imageDetailsWidth: finalWidth,
      // iconBackButtonColor: kGreenShadeColor,
      // hideBackButtonDetails: false,
      backgroundColorDetails: kBlueShadeColor,
      imageDetailsFit: BoxFit.cover,
      // hideAppBarDetails: true,
      imageFit: BoxFit.fill,
      withHeroAnimation: false,
      placeholderDetails: CircularProgressIndicator(color: kGreenShadeColor),
      placeholder: CircularProgressIndicator(color: kGreenShadeColor),
      errorWidget: urlDownload == ''
          ? CircularProgressIndicator(color: kGreenShadeColor)
          : Center(
              child: Text(
                'Image corrupted',
                style: TextStyle(color: Colors.red, fontSize: 32),
              ),
            ),
    );
  }
}

class ImageViewer1 extends StatelessWidget {
  const ImageViewer1({
    Key? key,
    required this.urlDownload,
    this.width = 150,
    this.height = 150,
    required this.finalWidth,
    required this.finalHeight,
  }) : super(key: key);

  final String urlDownload;
  final double width, height;
  final double finalHeight, finalWidth;

  @override
  Widget build(BuildContext context) {
    return ImageCachedFullscreen(
      imageUrl: urlDownload,
      imageBorderRadius: 20,
      imageWidth: width,
      imageHeight: height,
      imageDetailsHeight: finalHeight,
      imageDetailsWidth: finalWidth,
      // iconBackButtonColor: kGreenShadeColor,
      // hideBackButtonDetails: false,
      backgroundColorDetails: kBlueShadeColor,
      imageDetailsFit: BoxFit.cover,
      // hideAppBarDetails: true,
      imageFit: BoxFit.fill,
      withHeroAnimation: false,
      placeholderDetails: CircularProgressIndicator(color: kGreenShadeColor),
      placeholder: CircularProgressIndicator(color: kGreenShadeColor),
      errorWidget: urlDownload == ''
          ? CircularProgressIndicator(color: kGreenShadeColor)
          : Center(
              child: Text(
                'Image corrupted',
                style: TextStyle(color: Colors.red, fontSize: 32),
              ),
            ),
    );
  }
}

class ImageViewer2 extends StatelessWidget {
  const ImageViewer2({
    Key? key,
    required this.width,
    required this.height,
    required this.imageUrl,
  }) : super(key: key);

  final double width, height;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) {
        return SizedBox(
          height: height,
          width: width,
          child: CircularProgressIndicator(
            color: kGreenShadeColor,
            strokeWidth: 2,
          ),
        );
      },
      imageBuilder: (context, image) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(300),
          child: Image(
            image: image,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
