import 'package:vania/vania.dart';
import '../../models/product_note.dart';

class ProductNotesController extends Controller {
  // Mendapatkan semua data catatan produk
  Future<Response> index() async {
    final data = await ProductNote()
        .query()
        .select([
          'product_notes.*',
          'products.prod_name'
        ]) // Kolom tambahan dari tabel products
        .join('products', 'product_notes.prod_id', '=',
            'products.prod_id') // Gabungkan tabel products
        .orderBy('note_date', 'desc') // Urutkan berdasarkan tanggal
        .get();

    return Response.json({
      "message": "Berhasil mengambil daftar catatan produk",
      "data": data,
    });
  }

  // Menambahkan data catatan produk baru
  Future<Response> create(Request request) async {
    request.validate({
      'note_id': 'string|unique:product_notes,note_id', // note_id harus unik
      'prod_id': 'required|string|exists:products,prod_id', // Validasi prod_id
      'note_date': 'required|date', // Validasi format tanggal
      'note_text': 'required|string|max:255', // Validasi teks catatan
    });

    var input = request.input();

    // Validasi jika note_id otomatis
    if (input.containsKey('note_id') && input['note_id'].isEmpty) {
      input.remove('note_id');
    }

    await ProductNote().query().insert(input);

    return Response.json({
      "message": "Catatan produk berhasil ditambahkan",
      "data": input,
    }, 201);
  }

  // Menampilkan detail catatan produk berdasarkan note_id
  Future<Response> show(String noteId) async {
    final productNote = await ProductNote()
        .query()
        .select([
          'product_notes.*',
          'products.prod_name'
        ]) // Kolom tambahan dari tabel products
        .join('products', 'product_notes.prod_id', '=',
            'products.prod_id') // Gabungkan tabel products
        .where('note_id', '=', noteId)
        .first();

    if (productNote == null) {
      return Response.json({
        "message": "Catatan produk tidak ditemukan",
        "data": null,
      }, 404);
    }

    return Response.json({
      "message": "Berhasil mengambil data catatan produk",
      "data": productNote,
    });
  }

  // Memperbarui data catatan produk
  Future<Response> update(Request request, String noteId) async {
    final existingProductNote =
        await ProductNote().query().where('note_id', '=', noteId).first();

    if (existingProductNote == null) {
      return Response.json({
        "message": "Catatan produk tidak ditemukan",
        "data": null,
      }, 404);
    }

    request.validate({
      'prod_id': 'string|exists:products,prod_id', // Validasi prod_id
      'note_date': 'date', // Validasi format tanggal
      'note_text': 'string|max:255', // Validasi teks catatan
    });

    var input = request.input();
    await ProductNote().query().where('note_id', '=', noteId).update(input);

    return Response.json({
      "message": "Catatan produk berhasil diperbarui",
      "data": input,
    });
  }

  // Menghapus data catatan produk
  Future<Response> destroy(String noteId) async {
    final existingProductNote =
        await ProductNote().query().where('note_id', '=', noteId).first();

    if (existingProductNote == null) {
      return Response.json({
        "message": "Catatan produk tidak ditemukan",
        "data": null,
      }, 404);
    }

    await ProductNote().query().where('note_id', '=', noteId).delete();

    return Response.json({
      "message": "Catatan produk berhasil dihapus",
      "data": null,
    });
  }
}

// Buat instance dari controller
final ProductNotesController productNotesController = ProductNotesController();
