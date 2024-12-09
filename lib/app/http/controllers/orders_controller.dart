import 'package:vania/vania.dart';
import '../../models/order.dart';

class OrdersController extends Controller {
  // Menampilkan semua pesanan
  Future<Response> index() async {
    final data = await Order().query().get();

    return Response.json({
      "message": "Berhasil mengambil daftar pesanan",
      "data": data,
    });
  }

  // Membuat pesanan baru
  Future<Response> create(Request request) async {
    request.validate({
      'order_num':
          'integer|unique:orders,order_num', // Validasi unik jika disediakan
      'order_date': 'required|date',
      'cust_id': 'required|string|exists:customers,cust_id',
    });

    var input = request.input();

    // Jika order_num auto increment, hapus dari input
    if (input.containsKey('order_num')) {
      input.remove('order_num');
    }

    await Order().query().insert(input);

    return Response.json({
      "message": "Pesanan berhasil dibuat",
      "data": input,
    }, 201);
  }

  // Menampilkan detail pesanan berdasarkan order_num
  Future<Response> show(int id) async {
    final order = await Order().query().where('order_num', '=', id).first();

    if (order == null) {
      return Response.json({
        "message": "Pesanan tidak ditemukan",
        "data": null,
      }, 404);
    }

    return Response.json({
      "message": "Berhasil mengambil data pesanan",
      "data": order,
    });
  }

  // Menghapus pesanan berdasarkan order_num
  Future<Response> destroy(int id) async {
    final existingOrder =
        await Order().query().where('order_num', '=', id).first();

    if (existingOrder == null) {
      return Response.json({
        "message": "Pesanan tidak ditemukan",
        "data": null,
      }, 404);
    }

    await Order().query().where('order_num', '=', id).delete();

    return Response.json({
      "message": "Pesanan berhasil dihapus",
      "data": null,
    });
  }

  // Memperbarui pesanan berdasarkan order_num
  Future<Response> update(Request request, int id) async {
    final existingOrder =
        await Order().query().where('order_num', '=', id).first();

    if (existingOrder == null) {
      return Response.json({
        "message": "Pesanan tidak ditemukan",
        "data": null,
      }, 404);
    }

    request.validate({
      'order_num':
          'integer|unique:orders,order_num', // Validasi unik jika diubah
      'order_date': 'date',
      'cust_id': 'string|exists:customers,cust_id',
    });

    var input = request.input();

    await Order().query().where('order_num', '=', id).update(input);

    return Response.json({
      "message": "Pesanan berhasil diperbarui",
      "data": input,
    });
  }
}

// Buat instance dari controller
final OrdersController ordersController = OrdersController();
