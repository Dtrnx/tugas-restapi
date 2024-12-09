import 'package:vania/vania.dart';

class WebRoute implements Route {
  @override
  void register() {
    Router.get("/", () {
      return Response.html('welcome raka cuyy'.trans({'name': 'Vania'}));
    });
  }
}
