import 'package:vania/vania.dart';
import '../../models/vendor.dart';

class VendorsController extends Controller {
  // Utility untuk memindahkan vend_id ke posisi teratas
  Map<String, dynamic> reorderFields(Map<String, dynamic> data) {
    if (data.containsKey('vend_id')) {
      final vendId = data.remove('vend_id');
      return {
        'vend_id': vendId,
        ...data,
      };
    }
    return data;
  }

  // Menampilkan daftar vendor
  Future<Response> index() async {
    final data = await Vendor().query().orderBy('vend_name', 'asc').get();

    // Reorder vend_id untuk setiap vendor
    final reorderedData = data.map((vendor) => reorderFields(vendor)).toList();

    return Response.json({
      "message": "Berhasil mengambil daftar vendor",
      "data": reorderedData,
    });
  }

  // Membuat vendor baru
  Future<Response> create(Request request) async {
    request.validate({
      'vend_id':
          'required|string|unique:vendors,vend_id|max:5', // Validasi vend_id
      'vend_name': 'required|string|max:50',
      'vend_address': 'required|string',
      'vend_kota': 'required|string',
      'vend_state': 'required|string|max:5',
      'vend_zip': 'required|string|max:7',
      'vend_country': 'required|string|max:25',
    });

    var input = request.input();

    var existingVendor = await Vendor()
        .query()
        .where('vend_id', '=', input['vend_id'])
        .orWhere('vend_name', '=', input['vend_name'])
        .first();

    if (existingVendor != null) {
      return Response.json({
        "message": "Vendor sudah ada, tambahkan vendor lain.",
        "data": null,
      }, 409);
    }

    await Vendor().query().insert(input);

    final newVendor = reorderFields(input);

    return Response.json({
      "message": "Vendor berhasil ditambahkan",
      "data": newVendor,
    }, 201);
  }

  // Menampilkan detail vendor berdasarkan vend_id
  Future<Response> show(String id) async {
    final vendor = await Vendor().query().where('vend_id', '=', id).first();

    if (vendor == null) {
      return Response.json({
        "message": "Vendor tidak ditemukan",
        "data": null,
      }, 404);
    }

    final reorderedVendor = reorderFields(vendor);

    return Response.json({
      "message": "Berhasil mengambil data vendor",
      "data": reorderedVendor,
    });
  }

  // Memperbarui data vendor berdasarkan vend_id
  Future<Response> update(Request request, String id) async {
    request.validate({
      'vend_name': 'string|max:50',
      'vend_address': 'string',
      'vend_kota': 'string',
      'vend_state': 'string|max:5',
      'vend_zip': 'string|max:7',
      'vend_country': 'string|max:25',
    });

    final existingVendor =
        await Vendor().query().where('vend_id', '=', id).first();

    if (existingVendor == null) {
      return Response.json({
        "message": "Vendor tidak ditemukan",
        "data": null,
      }, 404);
    }

    var input = request.input();

    await Vendor().query().where('vend_id', '=', id).update(input);

    final updatedVendor = reorderFields({
      'vend_id': id,
      ...input,
    });

    return Response.json({
      "message": "Vendor berhasil diperbarui",
      "data": updatedVendor,
    });
  }

  // Menghapus vendor berdasarkan vend_id
  Future<Response> destroy(String id) async {
    final existingVendor =
        await Vendor().query().where('vend_id', '=', id).first();

    if (existingVendor == null) {
      return Response.json({
        "message": "Vendor tidak ditemukan",
        "data": null,
      }, 404);
    }

    await Vendor().query().where('vend_id', '=', id).delete();

    return Response.json({
      "message": "Vendor berhasil dihapus",
      "data": {
        "vend_id": id,
      },
    });
  }
}

// Buat instance dari controller
final VendorsController vendorsController = VendorsController();
