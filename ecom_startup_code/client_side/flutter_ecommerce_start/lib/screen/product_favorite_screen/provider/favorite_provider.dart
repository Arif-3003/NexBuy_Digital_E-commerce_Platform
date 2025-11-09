import 'package:e_commerce_flutter/utility/constants.dart';

import '../../../core/data/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/product.dart';


class FavoriteProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final box = GetStorage();
  List<Product>  favoriteProduct = [];
  FavoriteProvider(this._dataProvider);

  updateToFavouriteList(String productId) {
    List<dynamic>favouriteList  = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    if(favouriteList.contains(productId)){
      favouriteList.remove(productId);
    }
    else{
      favouriteList.add(productId);
    }
    checkIsItemFavorite(productId);
    box.write(FAVORITE_PRODUCT_BOX, favouriteList);
    loadFavoriteItems();
    notifyListeners();
  }
  bool checkIsItemFavorite(String productId){
    List<dynamic>favouriteList  = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    bool isExist=favouriteList.contains(productId);
    return isExist;
  }
  void loadFavoriteItems() {
    List<dynamic>favouriteListIds  = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    favoriteProduct=_dataProvider.products.where((product) {return favouriteListIds.contains(product.sId);}).toList();
    notifyListeners();
  }
  clearFavoriteList()
  {
    box.remove(FAVORITE_PRODUCT_BOX);
  }
}
