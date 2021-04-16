import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/e_provider_controller.dart';
import '../widgets/availability_hour_item_widget.dart';
import '../widgets/e_provider_til_widget.dart';
import '../widgets/e_provider_title_bar_widget.dart';
import '../widgets/featured_carousel_widget.dart';
import '../widgets/review_item_widget.dart';

class EProviderView extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _eProvider = controller.eProvider.value;
      if (!_eProvider.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEProvider(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildEProviderTitleBarWidget(_eProvider),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_eProvider),
                            buildCarouselBullets(_eProvider),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildContactUs(),
                        EProviderTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Text(_eProvider.description ?? '', style: Get.textTheme.bodyText1),
                        ),
                        buildAvailabilityHours(_eProvider),
                        buildAwards(),
                        buildExperiences(),
                        EProviderTilWidget(
                          horizontalPadding: 0,
                          title: Text("Featured Services".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                          content: FeaturedCarouselWidget(),
                          actions: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.E_PROVIDER_E_SERVICES, arguments: _eProvider);
                              },
                              child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            ).paddingSymmetric(horizontal: 20),
                          ],
                        ),
                        buildGalleries(),
                        EProviderTilWidget(
                          title: Text("Reviews & Ratings".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              Text(_eProvider.rate.toString(), style: Get.textTheme.headline1),
                              Wrap(
                                children: Ui.getStarsList(_eProvider.rate, size: 32),
                              ),
                              Text(
                                "Reviews (%s)".trArgs([_eProvider.totalReviews.toString()]),
                                style: Get.textTheme.caption,
                              ).paddingOnly(top: 10),
                              Divider(height: 35, thickness: 1.3),
                              Obx(() {
                                if (controller.reviews.isEmpty) {
                                  return CircularLoadingWidget(height: 100);
                                }
                                return ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return ReviewItemWidget(review: controller.reviews.elementAt(index));
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(height: 35, thickness: 1.3);
                                  },
                                  itemCount: controller.reviews.length,
                                  primary: false,
                                  shrinkWrap: true,
                                );
                              }),
                            ],
                          ),
                          actions: [
                            // TODO view all reviews
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Widget buildGalleries() {
    return Obx(() {
      if (controller.galleries.isEmpty) {
        return SizedBox();
      }
      return EProviderTilWidget(
        horizontalPadding: 0,
        title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
        content: Container(
          height: 120,
          child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: controller.galleries.length,
              itemBuilder: (_, index) {
                var _media = controller.galleries.elementAt(index);
                return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.GALLERY, arguments: {'media': controller.galleries, 'current': _media, 'heroTag': 'e_provide_galleries'});
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Hero(
                          tag: 'e_provide_galleries' + _media.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: _media.thumb,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 100,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                          child: Text(
                            _media.name ?? '',
                            maxLines: 2,
                            style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        actions: [
          // TODO show all galleries
        ],
      );
    });
  }

  EProviderTilWidget buildAvailabilityHours(EProvider _eProvider) {
    return EProviderTilWidget(
      title: Text("Availability".tr, style: Get.textTheme.subtitle2),
      content: _eProvider.availabilityHours.isEmpty
          ? CircularLoadingWidget(height: 150)
          : ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              itemCount: _eProvider.groupedAvailabilityHours().entries.length,
              separatorBuilder: (context, index) {
                return Divider(height: 16, thickness: 0.8);
              },
              itemBuilder: (context, index) {
                var _availabilityHour = _eProvider.groupedAvailabilityHours().entries.elementAt(index);
                var _data = _eProvider.getAvailabilityHoursData(_availabilityHour.key);
                return AvailabilityHourItemWidget(availabilityHour: _availabilityHour, data: _data);
              },
            ),
      actions: [
        if (_eProvider.available)
          Container(
            child: Text("Available".tr,
                maxLines: 1,
                style: Get.textTheme.bodyText2.merge(
                  TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                ),
                softWrap: false,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        if (!_eProvider.available)
          Container(
            child: Text("Offline".tr,
                maxLines: 1,
                style: Get.textTheme.bodyText2.merge(
                  TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                ),
                softWrap: false,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
      ],
    );
  }

  Widget buildAwards() {
    return Obx(() {
      if (controller.awards.isEmpty) {
        return SizedBox(height: 0);
      }
      return EProviderTilWidget(
        title: Text("Awards".tr, style: Get.textTheme.subtitle2),
        content: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.awards.length,
          separatorBuilder: (context, index) {
            return Divider(height: 16, thickness: 0.8);
          },
          itemBuilder: (context, index) {
            var _award = controller.awards.elementAt(index);
            return Column(
              children: [
                Text(_award.title ?? '').paddingSymmetric(vertical: 5),
                Text(
                  _award.description ?? '',
                  style: Get.textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          },
        ),
      );
    });
  }

  Widget buildExperiences() {
    return Obx(() {
      if (controller.experiences.isEmpty) {
        return SizedBox(height: 0);
      }
      return EProviderTilWidget(
        title: Text("Experiences".tr, style: Get.textTheme.subtitle2),
        content: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.experiences.length,
          separatorBuilder: (context, index) {
            return Divider(height: 16, thickness: 0.8);
          },
          itemBuilder: (context, index) {
            var _experience = controller.experiences.elementAt(index);
            return Column(
              children: [
                Text(_experience.title ?? '').paddingSymmetric(vertical: 5),
                Text(
                  _experience.description ?? '',
                  style: Get.textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          },
        ),
      );
    });
  }

  Container buildContactUs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact us".tr, style: Get.textTheme.subtitle2),
                Text("If your have any question!".tr, style: Get.textTheme.caption),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  launch("tel:${controller.eProvider.value.mobileNumber}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.accentColor,
                ),
                elevation: 0,
              ),
              MaterialButton(
                onPressed: () {
                  launch("tel:${controller.eProvider.value.phoneNumber}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                child: Icon(
                  Icons.call_outlined,
                  color: Get.theme.accentColor,
                ),
                elevation: 0,
              ),
              MaterialButton(
                onPressed: () {
                  controller.startChat();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                padding: EdgeInsets.zero,
                height: 44,
                minWidth: 44,
                child: Icon(
                  Icons.chat_outlined,
                  color: Get.theme.accentColor,
                ),
                elevation: 0,
              ),
            ],
          )
        ],
      ),
    );
  }

  CarouselSlider buildCarouselSlider(EProvider _eProvider) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 360,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _eProvider.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag + _eProvider.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 360,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(EProvider _eProvider) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _eProvider.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _eProvider.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EProviderTitleBarWidget buildEProviderTitleBarWidget(EProvider _eProvider) {
    return EProviderTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _eProvider.name ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              Container(
                child: Text(_eProvider.type?.name?.tr ?? ' . . . ',
                    maxLines: 1,
                    style: Get.textTheme.bodyText2.merge(
                      TextStyle(color: Get.theme.accentColor, height: 1.4, fontSize: 10),
                    ),
                    softWrap: false,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade),
                decoration: BoxDecoration(
                  color: Get.theme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List.from(Ui.getStarsList(_eProvider.rate ?? 0))
                    ..addAll([
                      SizedBox(width: 5),
                      Text(
                        "Reviews (%s)".trArgs([_eProvider.totalReviews.toString()]),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                ),
              ),
              Text(
                "Bookings (%s)".trArgs([_eProvider.bookingsInProgress.toString()]),
                style: Get.textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
