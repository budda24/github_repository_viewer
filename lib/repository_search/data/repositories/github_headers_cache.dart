import 'package:repository_search/authentication/data/data_sources/sembast_database.dart';
import 'package:repository_search/repository_search/data/models/github_headers.dart';

import 'package:sembast/sembast.dart';

class GithubHeadersCache {
  final SembastDatabase _sembastDatabase;

  final _store = stringMapStoreFactory.store('headers');

  GithubHeadersCache(this._sembastDatabase);

  Future<void> save(Uri uri, GithubHeaders githubHeaders) async {
    await _store.record(uri.toString()).put(
          _sembastDatabase.instance,
          githubHeaders.toJson(),
          merge: true,
        );
  }

  Future<GithubHeaders?> read(Uri uri) async {
    final json = await _store.record(uri.toString()).get(_sembastDatabase.instance);
    return json == null ? null : GithubHeaders.fromJson(json);
  }

  Future<void> delete(Uri uri) async {
    await _store.record(uri.toString()).delete(_sembastDatabase.instance);
  }
}
