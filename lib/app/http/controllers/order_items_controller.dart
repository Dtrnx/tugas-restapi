import 'package:vania/vania.dart';
import '../../models/order_item.dart';

class OrderItemsController extends Controller {
  // Mendapatkan semua data item pesanan
  Future<Response> index() async {
    final data = await OrderItem()
        .query()
        .select([
          'order_items.*',
          'products.prod_name',
          'products.prod_price'
        ]) // Kolom produk
        .join('products', 'order_items.prod_id', '=',
            'products.prod_id') // Gabungkan tabel products
        .get();

    return Response.json({
      "message": "Berhasil mengambil daftar item pesanan",
      "data": data,
    });
  }

  // Menambahkan data item pesanan baru
  Future<Response> create(Request request) async {
    request.validate({
      'order_num': 'required|int|exists:orders,order_num', // Validasi order_num
      'prod_id': 'required|string|exists:products,prod_id', // Validasi prod_id
      'quantity': 'required|int|min:1', // Validasi jumlah minimal 1
      'size': 'required|int|min:1', // Validasi ukuran minimal 1
    });

    var input = request.input();

    await OrderItem().query().insert(input);

    return Response.json({
      "message": "Item pesanan berhasil ditambahkan",
      "data": input,
    }, 201);
  }

  // Menampilkan detail item pesanan berdasarkan order_item
  Future<Response> show(int orderItemId) async {
    final orderItem = await OrderItem()
        .query()
        .select(['order_items.*', 'products.prod_name', 'products.prod_price'])
        .join('products', 'order_items.prod_id', '=', 'products.prod_id')
        .where('order_items.order_item', '=', orderItemId)
        .first();

    if (orderItem == null) {
      return Response.json({
        "message": "Item pesanan tidak ditemukan",
        "data": null,
      }, 404);
    }

    return Response.json({
      "message": "Berhasil mengambil data item pesanan",
      "data": orderItem,
    });
  }

  // Memperbarui data item pesanan berdasarkan order_item
  Future<Response> update(Request request, int orderItemId) async {
    request.validate({
      'order_num': 'int|exists:orders,order_num', // Validasi order_num
      'prod_id': 'string|exists:products,prod_id', // Validasi prod_id
      'quantity': 'int|min:1', // Validasi jumlah
      'size': 'int|min:1', // Validasi ukuran
    });

    final existingOrderItem =
        await OrderItem().query().where('order_item', '=', orderItemId).first();

    if (existingOrderItem == null) {
      return Response.json({
        "message": "Item pesanan tidak ditemukan",
        "data": null,
      }, 404);
    }

    var input = request.input();

    await OrderItem()
        .query()
        .where('order_item', '=', orderItemId)
        .update(input);

    return Response.json({
      "message": "Item pesanan berhasil diperbarui",
      "data": input,
    });
  }

  // Menghapus data item pesanan berdasarkan order_item
  Future<Response> destroy(int orderItemId) async {
    final existingOrderItem =
        await OrderItem().query().where('order_item', '=', orderItemId).first();

    if (existingOrderItem == null) {
      return Response.json({
        "message": "Item pesanan tidak ditemukan",
        "data": null,
      }, 404);
    }

    await OrderItem().query().where('order_item', '=', orderItemId).delete();

    return Response.json({
      "message": "Item pesanan berhasil dihapus",
      "data": null,
    });
  }
}

// Buat instance dari controller
final OrderItemsController orderItemsController = OrderItemsController();
