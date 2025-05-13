import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vehicle_manager/app/app_features/media_view/media_view_screen.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/components/vehicle_details_initial.dart';
import 'package:vehicle_manager/app/components/elevated_button.dart';

class MediaVeiwRoutebuilder extends StatelessWidget {
  final File mediaFile;
  final MediaType mediaType;
  final bool showBottomBar;
  final List<String>? detectedObjects;

  const MediaVeiwRoutebuilder({
    required this.mediaFile,
    required this.mediaType,
    required this.showBottomBar,
    this.detectedObjects,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image preview",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w500)),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: buildImagePreview()),
      bottomNavigationBar: !showBottomBar
          ? null
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.06,
                      child: CustomElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Retry")),
                    ),
                  ),
                  SizedBox(width: MediaQuery.sizeOf(context).width * 0.04),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.06,
                      child: CustomElevatedButton(
                        onPressed: () => Navigator.of(context).pop<bool>(true),
                        child: Text("Look's Good"),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildImagePreview() {
    switch (mediaType) {
      case MediaType.image:
        return ImageMediaViewScreen(
          imageFile: mediaFile,
          detectedObjects: detectedObjects,
        );
      case MediaType.video:
        return VideoMediaViewScreen(videoFile: mediaFile);
    }
  }
}
