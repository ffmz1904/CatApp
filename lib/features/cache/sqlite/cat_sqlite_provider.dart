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
  static final CatSqliteProvider _instance = CatSqliteProvider._();
  static Database? _db;

  factory CatSqliteProvider() {
    return _instance;
  }

  CatSqliteProvider._();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await create();
    return _db!;
  }

  Future<Database> create() async {
    final databasesPath = await getDatabasesPath();
    final path = databasesPath + '/$DB_NAME';

    return await openDatabase(path, version: 1,
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

  @override
  Future<List<CatModel>?> getLocalData() async {
    final cats = await getAll();
    print('get sqlite cache!');
    return cats;
  }

  @override
  Future<void> setLocalData(List<CatModel> data) async {
    await incertAll(data);
    print('Set sqlite cache !');
  }

  @override
  Future<void> closeConnection() async => _db!.close();

  Future<void> incertAll(List<CatModel> cats) async {
    cats.forEach((cat) async => { await insert(cat) });
  }

  Future<CatModel> insert(CatModel cat) async {
    final db = await database;
    cat.id = await db.insert(catTable, CatModel.toSqliteMap(cat));
    return cat;
  }

  Future<List<CatModel>?> getAll() async {
    final db = await database;
    List<Map> maps = await db.query(
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
}
