// import 'dart:io';
// import 'dart:math';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:sample/generated_images.dart';

// class MapUtils {
//   static BitmapDescriptor? _defaultAppMarker;
//   static BitmapDescriptor get defaultAppMarker =>
//       _defaultAppMarker ??
//       BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueViolet,
//       );

//   static void initData() {
//     ImageUtils.getBytesFromAsset(IcPng.icPurpleMarker, 120, 120).then((value) {
//       _defaultAppMarker = BitmapDescriptor.fromBytes(value);
//     }).catchError((error) {});
//   }

//   static Uri getGoogleMapUrl({
//     required double? lat,
//     required double? lng,
//     String? address,
//   }) {
//     final queryParameters = <String, String>{};
//     // 'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
//     queryParameters['api'] = '1';
//     queryParameters['query'] = '$lat,$lng($address)';

//     final googleUrl = Uri(
//       scheme: 'https',
//       host: 'www.google.com',
//       path: '/maps/search/',
//       queryParameters: queryParameters,
//     );
//     return googleUrl;
//   }

//   static Uri getGoogleMapDirectionUrl({
//     required double? latStart,
//     required double? lngStart,
//     required double? latEnd,
//     required double? lngEnd,
//     String? address,
//   }) {
//     final queryParameters = <String, String>{};
//     // 'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
//     queryParameters['api'] = '1';
//     if (latStart != null && lngStart != null) {
//       queryParameters['origin'] = '$latStart,$lngStart';
//     }
//     queryParameters['destination'] = '$latEnd,$lngEnd';

//     final googleUrl = Uri(
//       scheme: 'https',
//       host: 'www.google.com',
//       path: '/maps/dir/',
//       queryParameters: queryParameters,
//     );
//     return googleUrl;
//   }

//   static Future<bool> navigateTo(
//     double lat,
//     double lng, {
//     String? address,
//   }) async {
//     var googleUrl = getGoogleMapUrl(lat: lat, lng: lng, address: address);
//     if (Platform.isAndroid) {
//       return FutureUtils.processChains([
//         // () => UrlUtils.openUrl(Uri.parse("google.navigation:q=$lat,$lng")),
//         () => UrlUtils.openUrl(googleUrl),
//       ]);
//     }
//     if (Platform.isIOS) {
//       // final urlGoogleMap =
//       //     Uri.parse('comgooglemaps://?center=$lat,{lng}&zoom=12&views=traffic');
//       var urlAppleMaps = Uri.parse('https://maps.apple.com/?q=$lat,$lng');
//       return FutureUtils.processChains([
//         // () => UrlUtils.openUrl(urlGoogleMap),
//         () => UrlUtils.openUrl(googleUrl),
//         () => UrlUtils.openUrl(urlAppleMaps),
//       ]);
//     }
//     return false;
//   }

//   static Future<bool> directionTo(
//     double? latStart,
//     double? lngStart,
//     double latEnd,
//     double lngEnd, {
//     String? address,
//   }) async {
//     var googleUrl = getGoogleMapDirectionUrl(
//         latStart: latStart,
//         lngStart: lngStart,
//         latEnd: latEnd,
//         lngEnd: lngEnd,
//         address: address);
//     if (Platform.isAndroid) {
//       return FutureUtils.processChains([
//         // () => UrlUtils.openUrl(Uri.parse("google.navigation:q=$lat,$lng")),
//         () => UrlUtils.openUrl(googleUrl),
//       ]);
//     }
//     if (Platform.isIOS) {
//       // final urlGoogleMap =
//       //     Uri.parse('comgooglemaps://?center=$lat,{lng}&zoom=12&views=traffic');
//       // var urlAppleMaps = Uri.parse('https://maps.apple.com/?q=$lat,$lng');
//       return FutureUtils.processChains([
//         // () => UrlUtils.openUrl(urlGoogleMap),
//         () => UrlUtils.openUrl(googleUrl),
//         // () => UrlUtils.openUrl(urlAppleMaps),
//       ]);
//     }
//     return false;
//   }

//   static LatLngBounds computeBounds(List<LatLng> list) {
//     assert(list.isNotEmpty);
//     var firstLatLng = list.first;
//     var southLat = firstLatLng.latitude,
//         northLat = firstLatLng.latitude,
//         westLng = firstLatLng.longitude,
//         eastLng = firstLatLng.longitude;
//     for (var i = 1; i < list.length; i++) {
//       var latlng = list[i];
//       northLat = max(northLat, latlng.latitude);
//       eastLng = max(eastLng, latlng.longitude);
//       southLat = min(southLat, latlng.latitude);
//       westLng = min(westLng, latlng.longitude);
//     }
//     return LatLngBounds(
//       northeast: LatLng(northLat, eastLng),
//       southwest: LatLng(southLat, westLng),
//     );
//   }
// }
