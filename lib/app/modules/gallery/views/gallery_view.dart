import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../../../models/media_model.dart';
import '../controllers/gallery_controller.dart';

class GalleryView extends GetView<GalleryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(
          "Galleries".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => {Get.back()},
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (!controller.current.value.hasData) {
            return CircularLoadingWidget(height: 300);
          }
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Center(
                child: Hero(
                  tag: controller.heroTag.value + controller.current.value.id,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      viewportFraction: 1.0,
                      initialPage: controller.media.indexOf(controller.current.value),
                      onPageChanged: (index, reason) {
                        controller.current.value = controller.media.elementAt(index);
                      },
                    ),
                    items: controller.media.map((Media _media) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: _media.url,
                          placeholder: (context, url) => CircularLoadingWidget(height: 200),
                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
                        ),
                      ).marginSymmetric(horizontal: 20);
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(() {
                  return Text(
                    controller.current.value.name ?? '',
                    maxLines: 2,
                    style: Get.textTheme.bodyText2.merge(
                      TextStyle(
                        color: Get.theme.primaryColor,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 6.0,
                            color: Get.theme.hintColor.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
