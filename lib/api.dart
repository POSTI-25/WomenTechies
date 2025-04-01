const String baseUrl = "https://api.openrouteservice.org/v2/directions/driving-car";
const String apiKey = "5b3ce3597851110001cf624832591c235b714205ba65c64d75f9fb72";

getRouteUrl(String st_pt, String end_pt){
  return Uri.parse('$baseUrl?apikey=$apiKey&start=$st_pt&end=$end_pt');
}

