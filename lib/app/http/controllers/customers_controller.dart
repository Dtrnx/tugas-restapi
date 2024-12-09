import 'package:vania/vania.dart';
import '../../models/customer.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class CustomersController extends Controller {
  // Mendapatkan semua data pelanggan
  Future<Response> index() async {
    try {
      final data = await Customer().query().get();
      return Response.json({
        "message": "Berhasil mengambil daftar pelanggan",
        "data": data,
        "result": true,
      });
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data pelanggan",
        "result": false,
      }, 520);
    }
  }

  // Menambahkan data pelanggan baru
  Future<Response> create(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|string|max:5',
        'cust_name': 'required|string|max:50',
        'cust_address': 'required|string|max:50',
        'cust_city': 'required|string|max:20',
        'cust_state': 'required|string|max:5',
        'cust_zip': 'required|string|max:7',
        'cust_country': 'required|string|max:25',
        'cust_telp': 'required|string|max:15',
      });

      var input = request.input();

      var existingCustomer = await Customer()
          .query()
          .where('cust_id', '=', input['cust_id'])
          .first();

      if (existingCustomer != null) {
        return Response.json({
          "message": "Pelanggan dengan ID ini sudah ada, gunakan ID lain.",
          "result": false,
        }, 409);
      }

      await Customer().query().insert(input);

      return Response.json({
        "message": "Pelanggan berhasil ditambahkan",
        "result": true,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({
          "message": e.message,
          "result": false,
        }, e.code);
      }
      return Response.json({
        "message": "Terjadi kesalahan saat menambahkan pelanggan",
        "result": false,
      }, 520);
    }
  }

  // Menampilkan detail pelanggan berdasarkan cust_id
  Future<Response> show(String custId) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', custId).first();

      if (customer == null) {
        return Response.json({
          "message": "Pelanggan tidak ditemukan",
          "result": false,
        }, 404);
      }

      return Response.json({
        "message": "Berhasil mengambil data pelanggan",
        "data": customer,
        "result": true,
      });
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat mengambil data pelanggan",
        "result": false,
      }, 520);
    }
  }

  // Memperbarui data pelanggan
  Future<Response> update(Request request, String custId) async {
    try {
      request.validate({
        'cust_name': 'required|string|max:50',
        'cust_address': 'required|string|max:50',
        'cust_city': 'required|string|max:20',
        'cust_state': 'required|string|max:5',
        'cust_zip': 'required|string|max:7',
        'cust_country': 'required|string|max:25',
        'cust_telp': 'required|string|max:15',
      });

      final existingCustomer =
          await Customer().query().where('cust_id', '=', custId).first();

      if (existingCustomer == null) {
        return Response.json({
          "message": "Pelanggan tidak ditemukan",
          "result": false,
        }, 404);
      }

      var input = request.input();

      await Customer().query().where('cust_id', '=', custId).update(input);

      return Response.json({
        "message": "Pelanggan berhasil diperbarui",
        "result": true,
      });
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({
          "message": e.message,
          "result": false,
        }, e.code);
      }
      return Response.json({
        "message": "Terjadi kesalahan saat memperbarui pelanggan",
        "result": false,
      }, 520);
    }
  }

  // Menghapus data pelanggan
  Future<Response> destroy(String custId) async {
    try {
      final existingCustomer =
          await Customer().query().where('cust_id', '=', custId).first();

      if (existingCustomer == null) {
        return Response.json({
          "message": "Pelanggan tidak ditemukan",
          "result": false,
        }, 404);
      }

      await Customer().query().where('cust_id', '=', custId).delete();

      return Response.json({
        "message": "Pelanggan berhasil dihapus",
        "result": true,
      });
    } catch (e) {
      return Response.json({
        "message": "Terjadi kesalahan saat menghapus pelanggan",
        "result": false,
      }, 520);
    }
  }
}

final CustomersController customersController = CustomersController();
