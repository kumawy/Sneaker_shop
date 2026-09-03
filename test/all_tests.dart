import 'models/sneaker_model_test.dart' as sneaker_model;
import 'models/firebase_models_test.dart' as firebase_models;
import 'models/favourite_dao_test.dart' as favourite_dao;
import 'models/favourite_firebase_write_test.dart' as favourite_firebase_write;
import 'models/admin_product_firebase_write_test.dart' as admin_product_firebase_write;
import 'providers/cart_provider_test.dart' as cart_provider;
import 'providers/bookmark_provider_test.dart' as bookmark_provider;
import 'network/api_product_test.dart' as api_product;
import 'network/sneaker_api_service_test.dart' as api_service;

void main() {
  sneaker_model.main();
  firebase_models.main();
  favourite_dao.main();
  favourite_firebase_write.main();
  admin_product_firebase_write.main();
  cart_provider.main();
  bookmark_provider.main();
  api_product.main();
  api_service.main();
}
