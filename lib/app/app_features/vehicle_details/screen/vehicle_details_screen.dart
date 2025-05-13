import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/cubit/vehicle_details_cubit.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/components/vehicle_details_initial.dart';
import 'package:vehicle_manager/app/components/elevated_button.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Vehicle Details",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w500))),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: BlocBuilder<VehicleDetailsCubit, VehicleDetailsState>(
            builder: (context, state) {
              switch (state) {
                case VehicleDetailsInitial():
                  return VehicleDetailsInitialComponent(
                      images: state.images,
                      videos: state.videos,
                      vehicleType: state.vehicleType);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
                    child: Text("Cancel")),
              ),
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width * 0.04),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.06,
                child: CustomElevatedButton(
                    onPressed: () {
                      bool isValid = formKey.currentState?.validate() ?? false;
                      if (isValid) {
                        context
                            .read<VehicleDetailsCubit>()
                            .saveChangesPermenantly(context);
                      }
                    },
                    child: Text("Save")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
