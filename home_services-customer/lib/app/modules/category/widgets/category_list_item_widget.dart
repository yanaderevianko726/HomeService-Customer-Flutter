import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../routes/app_pages.dart';

class CategoryListItemWidget extends StatelessWidget {
  final Category category;
  final String heroTag;
  final bool expanded;

  CategoryListItemWidget({Key key, this.category, this.heroTag, this.expanded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: Ui.getBoxDecoration(
          border: Border.fromBorderSide(BorderSide.none),
          gradient: new LinearGradient(
              colors: [category.color.withOpacity(0.6), category.color.withOpacity(0.1)],
              begin: AlignmentDirectional.topStart, //const FractionalOffset(1, 0),
              end: AlignmentDirectional.topEnd,
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp)),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: this.expanded,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          title: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Theme.of(context).accentColor.withOpacity(0.08),
              onTap: () {
                Get.toNamed(Routes.CATEGORY, arguments: category);
                //Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: market.id, heroTag: heroTag));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: (category.image.url.toLowerCase().endsWith('.svg')
                        ? SvgPicture.network(
                            category.image.url,
                            color: category.color,
                            height: 100,
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: category.image.url,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category.name,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.bodyText2,
                    ),
                  ),
                  // TODO get service for each category
                  // Text(
                  //   "(" + category.services.length.toString() + ")",
                  //   overflow: TextOverflow.fade,
                  //   softWrap: false,
                  //   style: Get.textTheme.caption,
                  // ),
                ],
              )),
          children: List.generate(category.subCategories?.length ?? 0, (index) {
            var _category = category.subCategories.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.CATEGORY, arguments: _category);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Text(_category.name, style: Get.textTheme.bodyText1),
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor.withOpacity(0.2),
                  border: Border(top: BorderSide(color: Get.theme.scaffoldBackgroundColor.withOpacity(0.3))
                      //color: Get.theme.focusColor.withOpacity(0.2),
                      ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
