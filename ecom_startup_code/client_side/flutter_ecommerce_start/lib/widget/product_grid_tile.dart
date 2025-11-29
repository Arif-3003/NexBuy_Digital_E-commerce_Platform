import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screen/product_favorite_screen/provider/favorite_provider.dart';
import '../theme/app_color.dart';
import '../utility/extensions.dart';
import '../utility/utility_extention.dart';
import 'custom_network_image.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final int index;
  final bool isPriceOff;

  const ProductGridTile({
    super.key,
    required this.product,
    required this.index,
    required this.isPriceOff,
  });

  @override
  @override
  Widget build(BuildContext context) {
    double discountPercentage =
    context.dataProvider.calculateDiscountPercentage(
        product.price ?? 0, product.offerPrice ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8FC),       // ← NEW (soft background)
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),

      /// Stack added so OFF % can sit on top
      child: Stack(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Product image (UNCHANGED)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: Container(
                    color: const Color(0xFFF1F1F1),
                    child: CustomNetworkImage(
                      imageUrl: product.images!.isNotEmpty
                          ? product.images?.safeElementAt(0)?.url ?? ''
                          : '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              /// Product details (UNCHANGED)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(
                          product.offerPrice != 0
                              ? "\$${product.offerPrice}"
                              : "\$${product.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),

                        const SizedBox(width: 6),

                        if (product.offerPrice != null &&
                            product.offerPrice != product.price)
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// ❤️ Favourite Button (TOP-RIGHT)
          Positioned(
            top: 10,
            right: 10,
            child: Consumer<FavoriteProvider>(
              builder: (context, favProvider, child) {
                final isFav = favProvider.checkIsItemFavorite(product.sId ?? "");

                return GestureDetector(
                  onTap: () {
                    favProvider.updateToFavouriteList(product.sId ?? "");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),


          /// NEW → OFF % badge (top-left)
          if (discountPercentage != 0)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "OFF ${discountPercentage.toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
