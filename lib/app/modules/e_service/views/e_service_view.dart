import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../controllers/e_service_controller.dart';
import '../widgets/e_provider_item_widget.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';
import '../widgets/option_group_item_widget.dart';
import '../widgets/review_item_widget.dart';

class EServiceView extends GetView<EServiceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _eService = controller.eService.value;
      if (!_eService.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          bottomNavigationBar: buildBlockButtonWidget(_eService),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEService(showMessage: true);
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
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    actions: [
                      new IconButton(
                        icon: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Get.theme.primaryColor.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ]),
                          child: (_eService?.isFavorite ?? false) ? Icon(Icons.favorite, color: Colors.redAccent) : Icon(Icons.favorite_outline, color: Get.theme.hintColor),
                        ),
                        onPressed: () {
                          if (!Get.find<AuthService>().isAuth) {
                            Get.toNamed(Routes.LOGIN);
                          } else {
                            if (_eService?.isFavorite ?? false) {
                              controller.removeFromFavorite();
                            } else {
                              controller.addToFavorite();
                            }
                          }
                        },
                      ).marginSymmetric(horizontal: 10),
                    ],
                    bottom: buildEServiceTitleBarWidget(_eService),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_eService),
                            buildCarouselBullets(_eService),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildCategories(_eService),
                        EServiceTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Text(_eService.description, style: Get.textTheme.bodyText1),
                        ),
                        buildDuration(_eService),
                        buildOptions(),
                        buildServiceProvider(_eService),
                        EServiceTilWidget(
                          horizontalPadding: 0,
                          title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                          content: Container(
                            height: 120,
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemCount: _eService.images.length,
                                itemBuilder: (_, index) {
                                  var _media = _eService.images.elementAt(index);
                                  return InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.GALLERY, arguments: {'media': _eService.images, 'current': _media, 'heroTag': 'e_services_galleries'});
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                                      child: Stack(
                                        alignment: AlignmentDirectional.topStart,
                                        children: [
                                          Hero(
                                            tag: 'e_services_galleries' + _media.id,
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
                                              style: Get.textTheme.bodyText2.merge(TextStyle(
                                                color: Get.theme.primaryColor,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(0, 1),
                                                    blurRadius: 6.0,
                                                    color: Get.theme.hintColor.withOpacity(0.6),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          actions: [
                            // TODO View all galleries
                          ],
                        ),
                        EServiceTilWidget(
                          title: Text("Reviews & Ratings".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              Text(_eService.rate.toString(), style: Get.textTheme.headline1),
                              Wrap(
                                children: Ui.getStarsList(_eService.rate, size: 32),
                              ),
                              Text(
                                "Reviews (%s)".trArgs([_eService.totalReviews.toString()]),
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

  Widget buildOptions() {
    return Obx(() {
      if (controller.optionGroups.isEmpty) {
        return SizedBox(height: 0);
      }
      return EServiceTilWidget(
        horizontalPadding: 0,
        title: Text("Options".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
        content: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return OptionGroupItemWidget(optionGroup: controller.optionGroups.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 6);
          },
          itemCount: controller.optionGroups.length,
          primary: false,
          shrinkWrap: true,
        ),
      );
    });
  }

  Container buildDuration(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Duration".tr, style: Get.textTheme.subtitle2),
                Text("This service can take up to ".tr, style: Get.textTheme.bodyText1),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Text(_eService.duration, style: Get.textTheme.headline6),
        ],
      ),
    );
  }

  CarouselSlider buildCarouselSlider(EService _eService) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _eService.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _eService.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
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

  Container buildCarouselBullets(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _eService.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _eService.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(EService _eService) {
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _eService.name ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (_eService.eProvider == null)
                Container(
                  child: Text("  .  .  .  ".tr,
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_eService.eProvider != null && _eService.eProvider.available)
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_eService.eProvider != null && !_eService.eProvider.available)
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List.from(Ui.getStarsList(_eService.rate))
                    ..addAll([
                      SizedBox(width: 5),
                      Text(
                        "Reviews (%s)".trArgs([_eService.totalReviews.toString()]),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                ),
              ),
              Ui.getPrice(
                _eService.price,
                style: Get.textTheme.headline3.merge(TextStyle(color: Get.theme.accentColor)),
                unit: _eService.priceUnit != 'fixed' ? "/h".tr : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_eService.categories.length, (index) {
              var _category = _eService.categories.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: _category.color))),
                decoration: BoxDecoration(
                    color: _category.color.withOpacity(0.2),
                    border: Border.all(
                      color: _category.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_eService.subCategories.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_eService.subCategories.elementAt(index).name, style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildServiceProvider(EService _eService) {
    if (_eService?.eProvider?.hasData ?? false) {
      return EServiceTilWidget(
        title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
        content: EProviderItemWidget(provider: _eService.eProvider),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _eService.eProvider, 'heroTag': 'e_service_details'});
            },
            child: Text("View More".tr, style: Get.textTheme.subtitle1),
          ),
        ],
      );
    } else {
      return EServiceTilWidget(
        title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
        content: SizedBox(
          height: 60,
        ),
        actions: [],
      );
    }
  }

  Widget buildBlockButtonWidget(EService _eService) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Book This Service".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
            ],
          ),
          color: Get.theme.accentColor,
          onPressed: () {
            Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions()});
          }).paddingOnly(right: 20, left: 20),
    );
  }
}
