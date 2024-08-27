import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/services/date_convertion.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';

class ArticleTiles extends StatelessWidget {
  ArticleTiles({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 100,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(23.0),
                image: DecorationImage(
                  // image: Image.memory(base64Decode(article.image!)).image,
                  image: NetworkImage(article.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            HorizontalGap.formBig(),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelDefaultEmphasis(
                      article.title!,
                      textOverflow: TextOverflow.ellipsis,
                      context: context,
                      maxLines: 2,
                    ),
                    AppText.labelSmallEmphasis(
                      formatTanggal(article.createdAt!.toString()),
                      textOverflow: TextOverflow.ellipsis,
                      context: context,
                      color: color.textSecondary,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        VerticalGap.formMedium(),
      ],
    );
  }
}
