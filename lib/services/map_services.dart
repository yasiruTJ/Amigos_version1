import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/auto_complete_result.dart';

class MapServices {
  final String key = 'AIzaSyA0O18QK3GjutzA8ZAtGbDnTIy65lcera8';
  final String types = 'geocode';

  Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['predictions'] as List;

    return results.map((e) => AutoCompleteResult.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getPlace(String? input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<Map<String, dynamic>> getDirections(String origin,
      String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points'])
    };

    return results;
  }

  Future<dynamic> getPlaceDetails(LatLng cords, int radius, String type) async {
    var lat = cords.latitude;
    var lng = cords.longitude;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=$lat,$lng&radius=$radius&type=$type&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

  Future<String?> getPlaceId(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$input&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final placeInfo = results[0];
        return placeInfo['place_id'];
      } else {
        print('Place information not found.');
        return null;
      }
    } else {
      print('Failed to retrieve place information.');
      return null;
    }
  }

  Future<String?> getSelectedPlaceInfo(String placeId) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address,'
        'formatted_phone_number,editorial_summary,current_opening_hours,'
        'international_phone_number,website,photos,price_level&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];

      //name
      final name = result['name'] as String?;

      //address
      final address = result['formatted_address'] as String?;

      //contact details
      final contactDetails = result['formatted_phone_number'] as String?;

      //International phone number
      final internationalPhone = result['international_phone_number'] as String?;

      //website
      final website = result['website'] as String?;

      //summary
      final summary = result['editorial_summary'] as Map<String, dynamic>?;

      var overview;
      if (summary != null){
        overview = summary['overview'] as String?;
      }else{
        print('summary not available');
      }
      //accessing overview
      //openState and weekdays
      final openingHours = result['current_opening_hours'] as Map<String, dynamic>?;

      var openState = false;
      var weekdayString;
      if (openingHours != null) {
        final weekdays = openingHours['weekday_text'] as List<dynamic>;
        weekdayString = weekdays.join('\n');
        openState = (openingHours['open_now'] as bool?)!;

      } else {
        print('Opening hours data not available');
      }

      //priceLevel
      final int? priceLevel = result['price_level'];
      final String price;
      switch (priceLevel) {
        case 0:
          price = "Free";
          break;
        case 1:
          price = "Inexpensive";
          break;
        case 2:
          price = "Moderate";
          break;
        case 3:
          price = "Expensive";
          break;
        case 4:
          price = "Very Expensive";
          break;
        default:
          price = "No information found";
          break;
      }

      final photos = result['photos'] as List<dynamic>;

      String getPhotoUrl(String photoReference, int maxWidth) {
        return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$key';
      }


      List<String> photoUrls = [];

      for (var i = 0; i < photos.length && i < 10; i++) {
        final photoInfo = photos[i] as Map<String, dynamic>;
        final photoReference = photoInfo['photo_reference'] as String;
        final photoUrl = getPhotoUrl(photoReference, 800);
        photoUrls.add(photoUrl);
      }

      //creating a map with extracted data
      final placeDetails = {
        'name': name,
        'address': address,
        'phoneNumber': contactDetails,
        'summary': overview,
        'internationalPhone': internationalPhone,
        'website': website,
        'openState': openState,
        'openDays': weekdayString,
        'price': price,
        'photos': photoUrls
        // 'times' : openTimes
      };

      // Converting the map to a JSON string
      final jsonString = json.encode(placeDetails);

      return jsonString;
    } else {
      print('Failed to fetch place details');
      return null;
    }
  }

  //Dashboard stuff

  //popular destinations
  Future<List<Map<String, dynamic>>> getPopularDestinationsUK() async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=tourist+attractions+in+United+Kingdom&key=$key';

    List<Map<String, dynamic>> destinations = [];
    String? nextPageToken;

    do {
      // Construct the URL with the next page token if available
      final url = nextPageToken != null ? '$baseUrl&pagetoken=$nextPageToken' : baseUrl;

      // Fetch data from the current page
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        for (var result in results) {
          final String name = result['name'] as String;
          final String placeId = result['place_id'] as String;
          String imageUrl = '';
          if (result.containsKey('photos')) {
            final photoReference = result['photos'][0]['photo_reference'] as String;
            imageUrl =
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
          }
          destinations.add({
            'name': name,
            'placeId': placeId,
            'imageUrl': imageUrl,
          });
        }
        // Check if there's a next page token
        nextPageToken = data['next_page_token'];
      } else {
        throw Exception('Failed to fetch tourist attractions');
      }

      // Add a delay before making the next request (required by Places API)
      await Future.delayed(const Duration(seconds: 2));

    } while (nextPageToken != null);

    return destinations;
  }

  //destination Search
  Future<List<Map<String, dynamic>>> destinationSearch(String searchText) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchText+United+Kingdom&key=$key';

    List<Map<String, dynamic>> destination = [];

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      for (var result in results) {
        final String name = result['name'] as String;
        final String placeId = result['place_id'] as String;
        String imageUrl = '';
        if (result.containsKey('photos')) {
          final photoReference =
          result['photos'][0]['photo_reference'] as String;
          imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
        }
        destination.add({
          'name': name,
          'placeId': placeId,
          'imageUrl': imageUrl,
        });
      }
    }
    return destination;
  }


  //mountains
  Future<List<Map<String, dynamic>>> getMountainsUK() async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=mountains+in+United+Kingdom&key=$key';

    List<Map<String, dynamic>> mountains = [];

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      for (var result in results) {
        final String name = result['name'] as String;
        final String placeId = result['place_id'] as String;
        String imageUrl = '';
        if (result.containsKey('photos')) {
          final photoReference =
          result['photos'][0]['photo_reference'] as String;
          imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
        }
        mountains.add({
          'name': name,
          'placeId': placeId,
          'imageUrl': imageUrl,
        });
      }

      // Check if there is a next page of results
      if (data.containsKey('next_page_token')) {
        final nextPageToken = data['next_page_token'];
        final nextPageUrl =
            '$url&pagetoken=$nextPageToken';

        // Fetch results from the next page
        await Future.delayed(Duration(seconds: 2)); // Add delay before making the next request
        response = await http.get(Uri.parse(nextPageUrl));
        if (response.statusCode == 200) {
          final nextPageData = json.decode(response.body);
          final List<dynamic> nextPageResults = nextPageData['results'];
          for (var result in nextPageResults) {
            final String name = result['name'] as String;
            final String placeId = result['place_id'] as String;
            String imageUrl = '';
            if (result.containsKey('photos')) {
              final photoReference =
              result['photos'][0]['photo_reference'] as String;
              imageUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
            }
            mountains.add({
              'name': name,
              'placeId': placeId,
              'imageUrl': imageUrl,
            });
          }
        } else {
          throw Exception('Failed to fetch tourist attractions');
        }
      }
    } else {
      throw Exception('Failed to fetch tourist attractions');
    }

    return mountains;
  }

  //beaches
  Future<List<Map<String, dynamic>>> getBeachesUK() async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=beaches+in+United+Kingdom&key=$key';

    List<Map<String, dynamic>> beaches = [];

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      for (var result in results) {
        final String name = result['name'] as String;
        final String placeId = result['place_id'] as String;
        String imageUrl = '';
        if (result.containsKey('photos')) {
          final photoReference =
          result['photos'][0]['photo_reference'] as String;
          imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
        }
        beaches.add({
          'name': name,
          'placeId': placeId,
          'imageUrl': imageUrl,
        });
      }

      // Check if there is a next page of results
      if (data.containsKey('next_page_token')) {
        final nextPageToken = data['next_page_token'];
        final nextPageUrl =
            '$url&pagetoken=$nextPageToken';

        // Fetch results from the next page
        await Future.delayed(Duration(seconds: 2)); // Add delay before making the next request
        response = await http.get(Uri.parse(nextPageUrl));
        if (response.statusCode == 200) {
          final nextPageData = json.decode(response.body);
          final List<dynamic> nextPageResults = nextPageData['results'];
          for (var result in nextPageResults) {
            final String name = result['name'] as String;
            final String placeId = result['place_id'] as String;
            String imageUrl = '';
            if (result.containsKey('photos')) {
              final photoReference =
              result['photos'][0]['photo_reference'] as String;
              imageUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
            }
            beaches.add({
              'name': name,
              'placeId': placeId,
              'imageUrl': imageUrl,
            });
          }
        } else {
          throw Exception('Failed to fetch tourist attractions');
        }
      }
    } else {
      throw Exception('Failed to fetch tourist attractions');
    }

    return beaches;
  }

      Future<LatLng> fetchLatLngCoordinates(String placeId) async{
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final lat = data['result']['geometry']['location']['lat'] as double;
      final lng = data['result']['geometry']['location']['lng'] as double;
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to load location data');
    }
  }


  //MAPS
  Future<List<dynamic>> getRestaurants(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=restaurant'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }

  }

  Future<List<dynamic>> getHotels(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=lodging'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<dynamic>> getCafes(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=cafe'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<dynamic>> getActivities(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=amusement_park|aquarium|zoo|bowling_alley|casino|movie_theater|night_club'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<dynamic>> getParks(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=park'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<dynamic>> getPolice(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=police'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<dynamic>> getHospitals(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=hospital'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<dynamic>> getSupermarkets(double lat, double lng,int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=supermarket'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  //map
  Future<List<String>> fetchPhotoUrls(String photoReference,int maxImages) async {
    final List<String> imageUrls = [];

      String getImageUrl(String photoReference, int maxWidth) {
        return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$key';
      }

      // for (int i = 0; i<maxImages; i++){
      //
      // }
    final photoUrl = getImageUrl(photoReference, 800);
    imageUrls.add(photoUrl);
    return imageUrls;
    }

    //favourite Destinations
  Future<List<Map<String, dynamic>>> fetchFavPlaceDetails(List<String> favouritePlaceIds) async {
    List<Map<String, dynamic>> faveDestination = [];

    for (String id in favouritePlaceIds) {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=$key'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if 'result' exists and is not null
        if (data.containsKey('result') && data['result'] != null) {
          final result = data['result'];
          final String? name = result['name'] as String?;
          final String imageUrl = result['photos'] != null &&
              result['photos'].isNotEmpty
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${result['photos'][0]['photo_reference']}&key=$key'
              : 'https://via.placeholder.com/400x300'; // Placeholder image URL

          faveDestination.add({
            'name': name,
            'placeId': id,
            'imageUrl': imageUrl
          });
        } else {
          print('No result found for place ID: $id');
        }
      } else {
        print('Failed to load place details for ID: $id');
      }
    }

    return faveDestination;
  }

}
