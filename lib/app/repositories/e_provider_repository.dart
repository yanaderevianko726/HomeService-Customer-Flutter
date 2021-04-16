import 'package:get/get.dart';

import '../models/award_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';

class EProviderRepository {
  LaravelApiClient _laravelApiClient;

  EProviderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<EProvider> get(String eProviderId) {
    return _laravelApiClient.getEProvider(eProviderId);
  }

  Future<List<Review>> getReviews(String eProviderId) {
    return _laravelApiClient.getEProviderReviews(eProviderId);
  }

  Future<List<Gallery>> getGalleries(String eProviderId) {
    return _laravelApiClient.getEProviderGalleries(eProviderId);
  }

  Future<List<Award>> getAwards(String eProviderId) {
    return _laravelApiClient.getEProviderAwards(eProviderId);
  }

  Future<List<Experience>> getExperiences(String eProviderId) {
    return _laravelApiClient.getEProviderExperiences(eProviderId);
  }

  Future<List<EService>> getEServices(String eProviderId, {int page}) {
    return _laravelApiClient.getEProviderEServices(eProviderId, page);
  }

  Future<List<EService>> getPopularEServices(String eProviderId, {int page}) {
    return _laravelApiClient.getEProviderPopularEServices(eProviderId, page);
  }

  Future<List<EService>> getMostRatedEServices(String eProviderId, {int page}) {
    return _laravelApiClient.getEProviderMostRatedEServices(eProviderId, page);
  }

  Future<List<EService>> getAvailableEServices(String eProviderId, {int page}) {
    return _laravelApiClient.getEProviderAvailableEServices(eProviderId, page);
  }

  Future<List<EService>> getFeaturedEServices(String eProviderId, {int page}) {
    return _laravelApiClient.getEProviderFeaturedEServices(eProviderId, page);
  }
}
