import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastDatabase {
  late Database _instance;

  Database get instance => _instance;

  bool _hasBeenInitialized = false;

  Future<void> initialize() async {
    if (_hasBeenInitialized) {
      return;
    }
    _hasBeenInitialized = true;

    final docDirectory = await getApplicationDocumentsDirectory();
    await docDirectory.create(recursive: true);

    final dbPath = path.join(docDirectory.path, 'db.sembast');

    _instance = await databaseFactoryIo.openDatabase(dbPath);
  }
}
