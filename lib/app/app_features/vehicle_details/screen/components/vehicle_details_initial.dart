import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/cubit/vehicle_details_cubit.dart';
import 'package:vehicle_manager/app/components/elevated_button.dart';
import 'package:vehicle_manager/app/components/textform_field.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';

class VehicleDetailsInitialComponent extends StatefulWidget {
  final VehicleType? vehicleType;
  final List<String> images;
  final List<String> videos;

  const VehicleDetailsInitialComponent({
    this.vehicleType,
    required this.images,
    required this.videos,
    super.key,
  });

  @override
  State<VehicleDetailsInitialComponent> createState() =>
      _VehicleDetailsInitialComponentState();
}

class _VehicleDetailsInitialComponentState
    extends State<VehicleDetailsInitialComponent> {
  @override
  Widget build(BuildContext context) {
    VehicleDetailsCubit blocInstance = context.read<VehicleDetailsCubit>();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: blocInstance.companyTextController,
            labelText: "Company Name",
            validator: (value) => value == null || value.isEmpty
                ? "Company Name cannot be empty"
                : null,
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            controller: blocInstance.brandTextController,
            labelText: "Brand Name",
            validator: (value) => value == null || value.isEmpty
                ? "Brand Name cannot be empty"
                : null,
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            controller: blocInstance.modelTextController,
            labelText: "Model Name",
            validator: (value) => value == null || value.isEmpty
                ? "Model Name cannot be empty"
                : null,
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            controller: blocInstance.licenseNumberTextController,
            labelText: "License Number",
            validator: (value) => value == null || value.isEmpty
                ? "License Number cannot be empty"
                : null,
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<VehicleType>(
            hint: Text("Vehicle Type"),
            value: widget.vehicleType,
            items: List.from(VehicleType.values.map((e) =>
                DropdownMenuItem<VehicleType>(
                    value: e, child: Text(e.displayName)))),
            onChanged: (value) {
              if (value == null) return;
              context.read<VehicleDetailsCubit>().changeVehicleType(value);
            },
            validator: (value) =>
                value == null ? "Vehicle Type cannot be empty" : null,
          ),
          SizedBox(height: 20),
          Text("Images",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 17)),
          SizedBox(height: 20),
          MediaGridviewDisplay(
              mediaList: widget.images, mediaType: MediaType.image),
          SizedBox(height: 20),
          Text("Videos",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 17)),
          SizedBox(height: 20),
          MediaGridviewDisplay(
              mediaList: widget.videos, mediaType: MediaType.video),
          SizedBox(height: 16)
        ],
      ),
    );
  }
}

enum MediaType { image, video }

extension Name on MediaType {
  String get displayName {
    switch (this) {
      case MediaType.image:
        return "Image";
      case MediaType.video:
        return "Video";
    }
  }
}

class MediaGridviewDisplay extends StatelessWidget {
  final List<String> mediaList;
  final MediaType mediaType;

  const MediaGridviewDisplay({
    required this.mediaList,
    required this.mediaType,
    super.key,
  });

  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        title: Text("Confirmation",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w500)),
        content: Text("Are you sure you want to remove this media?"),
        actions: [
          CustomElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          CustomElevatedButton(
            onPressed: onConfirm,
            child: Text("Remove"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int length = mediaList.length + 1;

    return GridView.builder(
      itemCount: length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: MediaQuery.sizeOf(context).height * 0.15),
      itemBuilder: (context, index) {
        if (index == length - 1) {
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
              child: CustomElevatedButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  onPressed: () => context
                      .read<VehicleDetailsCubit>()
                      .openMediaPageForNewMedia(context, mediaType: mediaType),
                  child: Text("Add New ${mediaType.displayName}  +")),
            ),
          );
        }
        return InkWell(
          onTap: () => context.read<VehicleDetailsCubit>().previewMedia(context,
              mediaPath: mediaList[index], mediaType: mediaType),
          onLongPress: () => showConfirmationDialog(context, () {
            context
                .read<VehicleDetailsCubit>()
                .removeMedia(mediaList[index], mediaType: mediaType);
            Navigator.of(context).pop();
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey.shade900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${mediaType.displayName} ${index + 1}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                Text("Tap to preview",
                    style: TextStyle(
                        color: Colors.white.withAlpha(100),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                Text("Hold to remove",
                    style: TextStyle(
                        color: Colors.white.withAlpha(100),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
