import 'package:cat_app/features/cache/cache_provider.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:sqflite/sqflite.dart';

const DB_NAME = 'cat_app.db';

final String catTable = 'cats';
final String columnId = '_id';
final String columnCatId = 'catId';
final String columnFact = 'fact';
final String columnImage = 'image';
final String columnIsFavorite = 'isFavorite';
final String columnFavoriteId = 'favoriteId';

class CatSqliteProvider extends CacheProvider {
  Database? db;

  @override
  Future getLocalData() async {
    final path = await getPath();
    await open(path);

    final cats = await getAll();
    await close();
    print('get sqlite cache!');
    return cats;
  }

  @override
  Future<void> setLocalData(data) async {
    final path = await getPath();
    await open(path);
    await incertAll(data);
    print('Set sqlite cache !');
  }

  Future<String> getPath() async {
    var databasesPath = await getDatabasesPath();
    final path = databasesPath + '/$DB_NAME';
    return path;
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
              create table $catTable ( 
              $columnId integer primary key autoincrement, 
              $columnCatId text not null,
              $columnFact text not null,
              $columnImage text not null,
              $columnIsFavorite integer not null,
              $columnFavoriteId text)
            ''');
    });
  }

  Future incertAll(List<CatModel> cats) async {
    cats.forEach((cat) async => {await insert(cat)});
  }

  Future<CatModel> insert(CatModel cat) async {
    cat.id = await db!.insert(catTable, CatModel.toSqliteMap(cat));
    return cat;
  }

  Future<List<CatModel>?> getAll() async {
    List<Map> maps = await db!.query(
      catTable,
      columns: [
        columnCatId,
        columnFact,
        columnImage,
        columnIsFavorite,
        columnFavoriteId
      ],
    );

    if (maps.isNotEmpty) {
      final catList = maps.map((cat) => CatModel.fromSqliteMap(cat)).toList();
      return catList;
    }
    return null;
  }

  Future close() async => db!.close();
}
