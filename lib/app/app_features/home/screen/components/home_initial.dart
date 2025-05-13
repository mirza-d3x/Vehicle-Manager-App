import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/home/cubit/home_cubit.dart';
import 'package:vehicle_manager/app/components/elevated_button.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';

class HomeInitialComponent extends StatelessWidget {
  final List<VehicleInformation> vehicleInfoList;
  const HomeInitialComponent({required this.vehicleInfoList, super.key});

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
        content: Text("Are you sure you want to remove this vehicle?"),
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (vehicleInfoList.isEmpty)
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.3),
              child: Text("No vehicles Added",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
          ListView.separated(
              itemCount: vehicleInfoList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                VehicleInformation info = vehicleInfoList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  child: ListTile(
                    title: Text("${info.company} ${info.brand} ${info.model}"),
                    subtitle: Text("${info.registrationInfo.vehicleNumber}\n"
                        "${info.images.length} Images found, ${info.videos.length} Videos found"),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                    subtitleTextStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color
                                  ?.withAlpha(150),
                            ),
                    onTap: () => context
                        .read<HomeCubit>()
                        .openVehicleDetailsPage(context, info: info),
                    onLongPress: () {
                      showConfirmationDialog(context, () {
                        context
                            .read<HomeCubit>()
                            .removeVehicleInfo(context, info: info);
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 20)),
          SizedBox(height: 40),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.06,
            child: CustomElevatedButton(
                onPressed: () =>
                    context.read<HomeCubit>().openVehicleDetailsPage(context),
                child: Text("Add vehicle +")),
          )
        ],
      ),
    );
  }
}
