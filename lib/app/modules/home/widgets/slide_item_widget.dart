import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../routes/app_pages.dart';

class SlideItemWidget extends StatelessWidget {
  final Slide slide;

  const SlideItemWidget({
    this.slide,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(Directionality.of(context) == TextDirection.rtl ? math.pi : 0),
          child: CachedNetworkImage(
            width: double.infinity,
            height: 310,
            fit: Ui.getBoxFit(slide.imageFit),
            imageUrl: slide.image.url,
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
        ),
        Container(
            alignment: Ui.getAlignmentDirectional(slide.textPosition),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
            child: SizedBox(
              width: Get.width / 2.5,
              child: Column(
                children: [
                  if (slide.text != null && slide.text != '')
                    Text(
                      slide.text,
                      style: Get.textTheme.bodyText2.merge(TextStyle(color: slide.textColor)),
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                  if (slide.button != null && slide.button != '')
                    MaterialButton(
                      onPressed: () {
                        if (slide.eProvider != null) {
                          Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': slide.eProvider, 'heroTag': 'e_provider_slide_item'});
                        } else if (slide.eService != null) {
                          Get.toNamed(Routes.E_SERVICE, arguments: {'eService': slide.eService, 'heroTag': 'slide_item'});
                        }
                      },
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      color: slide.buttonColor,
                      shape: StadiumBorder(),
                      child: Text(
                        slide.button,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Get.theme.primaryColor),
                      ),
                      elevation: 0,
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: Ui.getCrossAxisAlignment(slide.textPosition),
              ),
            )),
      ],
    );
  }
}
