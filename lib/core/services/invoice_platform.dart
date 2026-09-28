export 'invoice_platform_stub.dart'
    if (dart.library.html) 'invoice_platform_web.dart'
    if (dart.library.io) 'invoice_platform_io.dart';
