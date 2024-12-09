import 'package:vania/vania.dart';
import 'package:restapi/app/http/controllers/products_controller.dart';
import 'package:restapi/app/http/controllers/orders_controller.dart';
import 'package:restapi/app/http/controllers/order_items_controller.dart';
import 'package:restapi/app/http/controllers/product_notes_controller.dart';
import 'package:restapi/app/http/controllers/customers_controller.dart';
import 'package:restapi/app/http/controllers/vendors_controller.dart';
import 'package:restapi/app/http/middleware/authenticate.dart';
import 'package:restapi/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    // Product Routes
    Router.get('/products', productsController.index);
    Router.post('/products', productsController.create);
    Router.get('/products/:id', productsController.show);
    Router.put('/products/:id', productsController.update);
    Router.delete('/products/:id', productsController.destroy);

    // Order Routes
    Router.get('/orders', ordersController.index);
    Router.post('/orders', ordersController.create);
    Router.get('/orders/:id', ordersController.show);
    Router.put('/orders/:id', ordersController.update);
    Router.delete('/orders/:id', ordersController.destroy);

    // OrderItem Routes
    Router.get('/order-items', orderItemsController.index);
    Router.post('/order-items', orderItemsController.create);
    Router.get('/order-items/:id', orderItemsController.show);
    Router.put('/order-items/:id', orderItemsController.update);
    Router.delete('/order-items/:id', orderItemsController.destroy);

    // ProductNote Routes
    Router.get('/product-notes', productNotesController.index);
    Router.post('/product-notes', productNotesController.create);
    Router.get('/product-notes/:id', productNotesController.show);
    Router.put('/product-notes/:id', productNotesController.update);
    Router.delete('/product-notes/:id', productNotesController.destroy);

    // Customer Routes
    Router.get('/customers', customersController.index);
    Router.post('/customers', customersController.create);
    Router.get('/customers/:id', customersController.show);
    Router.put('/customers/:id', customersController.update);
    Router.delete('/customers/:id', customersController.destroy);

    // Vendor Routes
    Router.get('/vendors', vendorsController.index);
    Router.post('/vendors', vendorsController.create);
    Router.get('/vendors/:id', vendorsController.show);
    Router.put('/vendors/:id', vendorsController.update);
    Router.delete('/vendors/:id', vendorsController.destroy);

    // Example Route with Middleware
    Router.get('/auth-user', () {
      return Response.json(Auth().user());
    }).middleware([AuthenticateMiddleware()]);

    // Example Error Response Route
    Router.get('/error-demo', () {
      return Response.json({'message': 'Invalid request!'});
    }).middleware([ErrorResponseMiddleware()]);
  }
}
