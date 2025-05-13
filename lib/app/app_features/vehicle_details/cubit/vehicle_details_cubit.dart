import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vehicle_manager/app/app_features/media_capture/screen/media_capture_routebuilder.dart';
import 'package:vehicle_manager/app/app_features/media_view/media_veiw_routebuilder.dart';
import 'package:vehicle_manager/app/app_features/vehicle_details/screen/components/vehicle_details_initial.dart';
import 'package:vehicle_manager/app/components/loader.dart';
import 'package:vehicle_manager/models/vehicle_info.dart';
import 'package:vehicle_manager/services/service_locator/service_locator.dart';

part 'vehicle_details_state.dart';

class VehicleDetailsCubit extends Cubit<VehicleDetailsState> {
  late final TextEditingController companyTextController;
  late final TextEditingController brandTextController;
  late final TextEditingController modelTextController;
  late final TextEditingController licenseNumberTextController;

  late VehicleType? _vehicleType;
  late final List<String> _images;
  late final List<String> _videos;

  final VehicleInformation? _vehicleInfo;

  VehicleDetailsCubit({required VehicleInformation? vehicleInfo})
      : _vehicleInfo = vehicleInfo,
        super(VehicleDetailsInitial(
            images: [...vehicleInfo?.images ?? []],
            videos: [...vehicleInfo?.videos ?? []],
            vehicleType: vehicleInfo?.vehicleType)) {
    // Initializing controllers and resources
    companyTextController = TextEditingController(text: _vehicleInfo?.company);
    brandTextController = TextEditingController(text: _vehicleInfo?.brand);
    modelTextController = TextEditingController(text: _vehicleInfo?.model);
    licenseNumberTextController = TextEditingController(
        text: _vehicleInfo?.registrationInfo.vehicleNumber);

    _vehicleType = _vehicleInfo?.vehicleType;
    _images = [..._vehicleInfo?.images ?? []];
    _videos = [..._vehicleInfo?.videos ?? []];
  }

  void changeVehicleType(VehicleType vehicleType) {
    if (vehicleType == _vehicleType) return;
    _vehicleType = vehicleType;
  }

  void openMediaPageForNewMedia(BuildContext context,
      {required MediaType mediaType}) async {
    File? imageFile = await Navigator.of(context).push<File>(MaterialPageRoute(
        builder: (context) => MediaCaptureRoutebuilder(mediaType: mediaType)));

    if (imageFile == null) return;

    switch (mediaType) {
      case MediaType.image:
        _images.add(imageFile.path);
        break;
      case MediaType.video:
        _videos.add(imageFile.path);
        break;
    }

    _sinkInitialState();
  }

  void previewMedia(BuildContext context,
      {required String mediaPath, required MediaType mediaType}) {
    File temperoryFile = File(mediaPath);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MediaVeiwRoutebuilder(
          mediaFile: temperoryFile,
          mediaType: mediaType,
          showBottomBar: false,
        ),
      ),
    );
  }

  void removeMedia(String mediaPath, {required MediaType mediaType}) {
    switch (mediaType) {
      case MediaType.image:
        return _removeImageMedia(mediaPath);
      case MediaType.video:
        return _removeVideoMedia(mediaPath);
    }
  }

  void _removeImageMedia(String mediaPath) {
    bool removed = _images.remove(mediaPath);
    if (removed) {
      _sinkInitialState();
    }
  }

  void _removeVideoMedia(String mediaPath) {
    bool removed = _videos.remove(mediaPath);
    if (removed) {
      _sinkInitialState();
    }
  }

  void saveChangesPermenantly(BuildContext context) async {
    try {
      bool changesRecorded = _changesPresentFromAction();

      if (!changesRecorded) {
        Navigator.of(context).pop();
        return;
      }

      CustomProgressIndicator.showLoader(context);

      final List<String> images =
          await _saveMediaFiles([_vehicleInfo?.images ?? [], _images]);

      _images.clear();
      _images.addAll(images);

      String vehicleInfoId =
          _vehicleInfo?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      VehicleInformation newInfo = VehicleInformation(
        company: companyTextController.text.trim(),
        brand: brandTextController.text.trim(),
        model: modelTextController.text.trim(),
        vehicleType: _vehicleType!,
        images: _images,
        videos: _videos,
        registrationInfo: RegistrationInformation(
            vehicleNumber: licenseNumberTextController.text.trim()),
        id: vehicleInfoId,
      );

      await _saveDataToDatabase(newInfo);

      if (context.mounted) {
        CustomProgressIndicator.removeLoader(context);
        Navigator.of(context).pop<VehicleInformation>(newInfo);
      }
    } catch (error, stack) {
      log("Exception occurred while saving user action changes",
          error: error, stackTrace: stack);
      if (context.mounted) {
        CustomProgressIndicator.removeLoader(context);
      }
    }
  }

  Future<List<String>> _saveMediaFiles(List<List<String>> data) async {
    try {
      List<String> oldMediaFiles = data[0];
      List<String> newMediaFiles = data[1];

      oldMediaFiles = [...oldMediaFiles];
      newMediaFiles = [...newMediaFiles];

      Set<String> oldSet = oldMediaFiles.toSet();
      Set<String> newSet = newMediaFiles.toSet();

      List<String> removedFiles = oldSet.difference(newSet).toList();
      List<String> addedFiles = newSet.difference(oldSet).toList();

      if (removedFiles.isNotEmpty) {
        for (String mediaFilePath in removedFiles) {
          try {
            File file = File(mediaFilePath);
            bool fileExists = await file.exists();
            if (fileExists) {
              await file.delete();
            }
          } catch (error, stack) {
            log(
                "Exception occurred while "
                "deleting Media File from directory. "
                "Directory path: $mediaFilePath",
                error: error,
                stackTrace: stack);
          }
        }
      }

      if (addedFiles.isNotEmpty) {
        for (String mediaFilePath in addedFiles) {
          newMediaFiles.remove(mediaFilePath);
        }

        Directory appDirectory = await getApplicationDocumentsDirectory();
        String appDirectoryPath = appDirectory.path;

        for (int i = 0; i < addedFiles.length; i++) {
          String mediaFilePath = addedFiles[i];
          String mediaFileName = mediaFilePath.split("/").last;
          File mediaFile = File(mediaFilePath);

          String newMediaFilePath = "$appDirectoryPath/$mediaFileName";
          await mediaFile.copy(newMediaFilePath);
          addedFiles[i] = newMediaFilePath;
        }
      }
      return [...newMediaFiles, ...addedFiles];
    } catch (error, stack) {
      log(
          "Exception occurred while updating Media Files. "
          "This Exception is serious as the actual files "
          "where failed to be updated",
          error: error,
          stackTrace: stack);
      rethrow;
    }
  }

  bool _changesPresentFromAction() {
    if (_vehicleInfo == null) return true;

    VehicleInformation info = _vehicleInfo;

    bool hasTextChanges = info.company != companyTextController.text.trim() ||
        info.brand != brandTextController.text.trim() ||
        info.model != modelTextController.text.trim() ||
        info.registrationInfo.vehicleNumber !=
            licenseNumberTextController.text.trim();

    if (hasTextChanges) return true;

    if (info.vehicleType != _vehicleType) return true;

    if (_images.length != info.images.length) return true;
    if (_videos.length != info.videos.length) return true;

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != info.images[i]) return true;
    }

    for (int i = 0; i < _videos.length; i++) {
      if (_videos[i] != info.videos[i]) return true;
    }

    return false;
  }

  Future<void> _saveDataToDatabase(VehicleInformation vehicleInfo) async {
    if (_vehicleInfo == null) {
      await ServiceLocator.instance.vehicleDatabase
          .create(key: vehicleInfo.id, data: vehicleInfo);
    } else {
      await ServiceLocator.instance.vehicleDatabase
          .update(key: vehicleInfo.id, data: vehicleInfo);
    }
  }

  void _sinkInitialState() => emit(VehicleDetailsInitial(
      images: _images, videos: _videos, vehicleType: _vehicleType));
}
