import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/coupon_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/favorite_model.dart';
import '../models/gallery_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../models/user_model.dart';
import 'api_provider.dart';

class LaravelApiClient extends GetxService with ApiClient {
  Dio _httpClient;
  Options _optionsNetwork;
  Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = new Dio();
  }

  Future<LaravelApiClient> init() async {
    _optionsNetwork = buildCacheOptions(Duration(days: 3), forceRefresh: true);
    _optionsCache = buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
    _httpClient.interceptors.add(DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    _optionsCache = buildCacheOptions(duration, forceRefresh: true);
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    _optionsCache = buildCacheOptions(duration, forceRefresh: false);
  }

  Future<List<Slide>> getHomeSlider() async {
    Uri _uri = getApiBaseUri("slides");
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("login");
    print('login url ===> ' + _uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("register");
    print(_uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("users/${user.id}").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
    };
    Uri _uri = getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getRecommendedEServices() async {
    // TODO get Only Recommended
    const _queryParameters = {
      'only': 'id;name;price;discount_price;price_unit;has_media;media;total_reviews;rate',
      'limit': '6',
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getAllEServicesWithPagination(String categoryId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> searchEServices(String keywords, List<String> categories, int page) async {
    // TODO Pagination
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Favorite>> getFavoritesEServices() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFavoritesEServices() ]");
    }
    var _queryParameters = {
      'with': 'eService;options;eService.eProvider',
      'search': 'user_id:${authService.user.value.id}',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Favorite>((obj) => Favorite.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Favorite> addFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception("You must have an account to be able to add services to favorite".tr + "[ addFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return Favorite.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> removeFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception("You must have an account to be able to add services to favorite".tr + "[ removeFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("favorites/1").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.deleteUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;categories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<EProvider> getEProvider(String eProviderId) async {
    const _queryParameters = {
      'with': 'eProviderType;availabilityHours;users',
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getEProviderReviews(String eProviderId) async {
    var _queryParameters = {'with': 'eProviderReviews;eProviderReviews.user', 'only': 'eProviderReviews.id;eProviderReviews.review;eProviderReviews.rate;eProviderReviews.user;'};
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data']['e_provider_reviews'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Gallery>> getEProviderGalleries(String eProviderId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("galleries").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Gallery>((obj) => Gallery.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getEProviderAwards(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Award>((obj) => Award.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getEProviderExperiences(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Experience>((obj) => Experience.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId;featured:1',
      'searchFields': 'e_provider_id:=;featured:=',
      'searchJoin': 'and',
      'limit': '5',
      'offset': ((page - 1) * 5).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderPopularEServices(String eProviderId, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(String eProviderId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderEServices(String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {'with': 'user', 'only': 'created_at;review;rate;user', 'search': "e_service_id:$eServiceId", 'orderBy': 'created_at', 'sortBy': 'desc', 'limit': '10'};
    Uri _uri = getApiBaseUri("e_service_reviews").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options',
      'only': 'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getFeaturedEServices(String categoryId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId;featured:1',
      'searchFields': 'categories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getPopularEServices(String categoryId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getMostRatedEServices(String categoryId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getAvailableEServices(String categoryId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.statusCode == 200) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    const _queryParameters = {
      'with': 'featuredEServices',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.statusCode == 200) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Booking>> getBookings(String statusId, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      // 'search': 'user_id:${authService.user.value.id}',
      'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Booking>((obj) => Booking.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("booking_statuses").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingStatus>((obj) => BookingStatus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with': 'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Coupon> validateCoupon(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': booking.coupon?.code ?? '',
      'e_service_id': booking.eService?.id ?? '',
      'e_provider_id': booking.eService?.eProvider?.id ?? '',
      'categories_id': booking.eService?.categories?.map((e) => e.id)?.join(",") ?? '',
    };
    Uri _uri = getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Coupon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.putUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> addBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.postUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addReview(Review review) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_service_reviews").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.postUri(_uri, data: review.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paypal/express-checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '10',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Notification>((obj) => Notification.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.putUri(_uri, data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<FaqCategory>((obj) => FaqCategory.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Faq>((obj) => Faq.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("settings");
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages").replace(queryParameters: _queryParameters);
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<CustomPage>((obj) => CustomPage.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    print(_uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
