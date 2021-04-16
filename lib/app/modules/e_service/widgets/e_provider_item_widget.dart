import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/e_provider_model.dart';

class EProviderItemWidget extends StatelessWidget {
  final EProvider provider;

  EProviderItemWidget({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                height: 65,
                width: 65,
                fit: BoxFit.cover,
                imageUrl: provider.firstImageThumb,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  height: 65,
                  width: 65,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    provider.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).hintColor)),
                  ),
                  SizedBox(height: 5),
                  Text(
                    provider.description ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
              child: Chip(
                padding: EdgeInsets.all(0),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(provider.rate.toString(), style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
                    Icon(
                      Icons.star_border,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                shape: StadiumBorder(),
              ),
            ),
          ],
        ),
        // Text(
        //   review.review,
        //   style: Theme.of(context).textTheme.caption,
        //   overflow: TextOverflow.ellipsis,
        //   softWrap: false,
        //   maxLines: 3,
        // )
      ],
    );
  }
}
