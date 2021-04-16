import 'category_model.dart';
import 'e_provider_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class EService extends Model {
  String id;
  String name;
  String description;
  List<Media> images;
  double price;
  double discountPrice;
  String priceUnit;
  double rate;
  int totalReviews;
  String duration;
  bool featured;
  bool isFavorite;
  List<Category> categories;
  List<Category> subCategories;
  EProvider eProvider;

  EService(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.price,
      this.discountPrice,
      this.priceUnit,
      this.rate,
      this.totalReviews,
      this.duration,
      this.featured,
      this.isFavorite,
      this.categories,
      this.subCategories,
      this.eProvider});

  EService.fromJson(Map<String, dynamic> json) {
    name = stringFromJson(json, 'name');
    description = stringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    price = doubleFromJson(json, 'price');
    discountPrice = doubleFromJson(json, 'discount_price');
    priceUnit = stringFromJson(json, 'price_unit');
    rate = doubleFromJson(json, 'rate');
    totalReviews = intFromJson(json, 'total_reviews');
    duration = stringFromJson(json, 'duration');
    featured = boolFromJson(json, 'featured');
    isFavorite = boolFromJson(json, 'is_favorite');
    categories = listFromJson<Category>(json, 'categories', (value) => Category.fromJson(value));
    subCategories = listFromJson<Category>(json, 'sub_categories', (value) => Category.fromJson(value));
    eProvider = objectFromJson(json, 'e_provider', (value) => EProvider.fromJson(value));
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['price_unit'] = this.priceUnit;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['duration'] = this.duration;
    data['featured'] = this.featured;
    data['is_favorite'] = this.isFavorite;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.subCategories != null) {
      data['sub_categories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    if (this.eProvider != null) {
      data['e_provider'] = this.eProvider.toJson();
    }
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

  /*
  * Get the real price of the service
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */
  double get getPrice {
    return discountPrice > 0 ? discountPrice : price;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is EService &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          rate == other.rate &&
          isFavorite == other.isFavorite &&
          categories == other.categories &&
          subCategories == other.subCategories &&
          eProvider == other.eProvider;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ rate.hashCode ^ eProvider.hashCode ^ categories.hashCode ^ subCategories.hashCode ^ isFavorite.hashCode;
}
