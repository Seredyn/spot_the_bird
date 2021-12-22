import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial()); //Это будет инитиалстате

  Future<void> getPermission() async {
    //await Geolocator.openAppSettings();
    //await Geolocator.openLocationSettings();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      //return Future.error('Location services are disabled.');
      print("serviceEnabled - false");
      //return Future.error('Location services are disabled.');
      emit(LocationError());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print("Location permissions are denied");
        emit(LocationError());
      }
    }

    //LocationPermission permission = await Geolocator.checkPermission(); //checkPermission() - это статический метод, поэтому можно вызвать не создавая объект этого класса

    //print(permission.toString());

    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      emit(LocationLoading());

      try {
        Position position = await Geolocator.getCurrentPosition(
            //тоже статический метод, который можно использовать без инициализации класса
            desiredAccuracy: LocationAccuracy.high);

        emit(LocationLoaded(
            latitude: position.latitude, longitude: position.longitude));
      } catch (error) {
        print(error.toString());
        emit(LocationError());
      }
    }

    // if (permission == LocationPermission.denied){
    //   emit(LocationPermissionDenied());
    // }
  }
}
