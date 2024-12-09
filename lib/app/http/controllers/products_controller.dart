import 'package:vania/vania.dart';
import '../../models/product.dart';

class ProductsController extends Controller {
  // Utility untuk memindahkan prod_id ke posisi teratas
  Map<String, dynamic> reorderFields(Map<String, dynamic> data) {
    if (data.containsKey('prod_id')) {
      final prodId = data.remove('prod_id');
      return {
        'prod_id': prodId,
        ...data,
      };
    }
    return data;
  }

  // Menampilkan daftar produk
  Future<Response> index() async {
    final data = await Product()
        .query()
        .select(['products.*', 'vendors.vend_name'])
        .join('vendors', 'products.vend_id', '=', 'vendors.vend_id')
        .orderBy('prod_name', 'asc')
        .get();

    // Reorder prod_id untuk setiap produk
    final reorderedData =
        data.map((product) => reorderFields(product)).toList();

    return Response.json({
      "message": "Berhasil mengambil daftar produk",
      "data": reorderedData,
    });
  }

  // Membuat produk baru
  Future<Response> create(Request request) async {
    request.validate({
      'prod_id': 'string|unique:products,prod_id', // Validasi unik prod_id
      'prod_name': 'required|string|max:25',
      'prod_desc': 'required|string',
      'prod_price': 'required|int|min:1',
      'vend_id': 'required|string|exists:vendors,vend_id',
    });

    var input = request.input();

    // Jika prod_id auto-generated, hapus dari input
    if (input.containsKey('prod_id') && input['prod_id'].isEmpty) {
      input.remove('prod_id');
    }

    var existingProduct = await Product()
        .query()
        .where('prod_name', '=', input['prod_name'])
        .first();

    if (existingProduct != null) {
      return Response.json({
        "message": "Produk sudah ada, tambahkan produk lain.",
        "data": null,
      }, 409);
    }

    await Product().query().insert(input);

    final newProduct = reorderFields(input);

    return Response.json({
      "message": "Produk berhasil ditambahkan",
      "data": newProduct,
    }, 201);
  }

  // Menampilkan detail produk berdasarkan prod_id
  Future<Response> show(String id) async {
    final product = await Product()
        .query()
        .select(['products.*', 'vendors.vend_name'])
        .join('vendors', 'products.vend_id', '=', 'vendors.vend_id')
        .where('prod_id', '=', id)
        .first();

    if (product == null) {
      return Response.json({
        "message": "Produk tidak ditemukan",
        "data": null,
      }, 404);
    }

    final reorderedProduct = reorderFields(product);

    return Response.json({
      "message": "Berhasil mengambil data produk",
      "data": reorderedProduct,
    });
  }

  // Memperbarui data produk berdasarkan prod_id
  Future<Response> update(Request request, String id) async {
    request.validate({
      'prod_name': 'string|max:25',
      'prod_desc': 'string',
      'prod_price': 'int|min:1',
      'vend_id': 'string|exists:vendors,vend_id',
    });

    final existingProduct =
        await Product().query().where('prod_id', '=', id).first();

    if (existingProduct == null) {
      return Response.json({
        "message": "Produk tidak ditemukan",
        "data": null,
      }, 404);
    }

    var input = request.input();

    await Product().query().where('prod_id', '=', id).update(input);

    final updatedProduct = reorderFields({
      'prod_id': id,
      ...input,
    });

    return Response.json({
      "message": "Produk berhasil diperbarui",
      "data": updatedProduct,
    });
  }

  // Menghapus produk berdasarkan prod_id
  Future<Response> destroy(String id) async {
    final existingProduct =
        await Product().query().where('prod_id', '=', id).first();

    if (existingProduct == null) {
      return Response.json({
        "message": "Produk tidak ditemukan",
        "data": null,
      }, 404);
    }

    await Product().query().where('prod_id', '=', id).delete();

    return Response.json({
      "message": "Produk berhasil dihapus",
      "data": {
        "prod_id": id,
      },
    });
  }
}

// Buat instance dari controller
final ProductsController productsController = ProductsController();
