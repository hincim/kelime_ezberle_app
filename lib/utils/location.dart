
import 'package:geolocator/geolocator.dart';
import 'package:kelimeezberle/global/my_widgets/toast.dart';

class LocationHelper {
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async {

    try{
      LocationPermission check = await Geolocator.requestPermission();
      if(check == LocationPermission.denied){
        showToast("Konum izini reddedildi");
      }
      else if (check == LocationPermission.deniedForever) {
        showToast(
            'Konum izni kalıcı olarak reddedildi.');

      }
    }catch(e){
      showToast("Konum alınamadı");
    }

    var location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // hassasiyeti high olsun.
    latitude = location.latitude;
    longitude = location.longitude;

  }

}
