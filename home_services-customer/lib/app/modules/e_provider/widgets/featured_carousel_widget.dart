import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/e_provider_controller.dart';

class FeaturedCarouselWidget extends GetWidget<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Get.theme.primaryColor,
      child: GetX(builder: (context) {
        if (controller.featuredEServices.isEmpty) {
          return CircularLoadingWidget(height: 250);
        }
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.featuredEServices.length,
            itemBuilder: (_, index) {
              var _service = controller.featuredEServices.elementAt(index);
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _service, 'heroTag': 'featured_carousel'});
                },
                child: Container(
                  width: 160,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'featured_carousel' + _service.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _service.firstImageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 140,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        height: 115,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              _service.name ?? '',
                              maxLines: 2,
                              style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                            ),
                            Wrap(
                              children: Ui.getStarsList(_service.rate),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              alignment: WrapAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  "Start from".tr,
                                  style: Get.textTheme.caption,
                                ),
                                Ui.getPrice(
                                  _service.price,
                                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.accentColor)),
                                  unit: _service.priceUnit != 'fixed' ? "/h".tr : null,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
