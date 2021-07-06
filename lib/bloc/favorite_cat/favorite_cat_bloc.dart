// import 'package:cat_app/bloc/cat/cat_events.dart';
// import 'package:cat_app/bloc/cat/cat_state.dart';
// import 'package:cat_app/bloc/favorite_cat/favorite_cat_events.dart';
// import 'package:cat_app/bloc/favorite_cat/favorite_cat_state.dart';
// import 'package:cat_app/features/cats/model/cat_model.dart';
// import 'package:cat_app/features/cats/repositories/cat_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FavoriteCatBloc extends Bloc<CatEvent, CatState> {
//   CatRepository repository = CatRepository();

//   FavoriteCatBloc() : super(FavoriteCatEmptyState());

//   @override
//   Stream<CatState> mapEventToState(CatEvent event) async* {
//     if (event is FavoriteCatLoadEvent) {
//       yield* _mapFavoriteCatLoadToState(event);
//     } else if (event is CatAddToFavoriteEvent) {
//       yield* _mapFavoriteAddCatToState(event);
//     } else if (event is CatRemoveFromFavoritesEvent) {
//       yield* _mapFavoriteCatRemoveToState(event);
//     }
//   }

//   Stream<CatState> _mapFavoriteCatLoadToState(CatEvent event) async* {
//     if (state is FavoriteCatEmptyState) {
//       yield FavoriteCatLoadingState();
//     }

//     FavoriteCatLoadEvent eventData = (event as FavoriteCatLoadEvent);

//     int limit = 5;
//     int page = eventData.page;
//     String userId = eventData.userId;

//     try {
//       List<CatModel> cats;
//       List<CatModel> loadedCats =
//           await repository.getUserFavorites(userId, limit, page);

//       if (page != 0) {
//         cats = (state as FavoriteCatLoadedState).catList;
//         cats.addAll(loadedCats);
//       } else {
//         cats = loadedCats;
//       }

//       if (cats.isNotEmpty) {
//         await repository.setCatLocal(catList: cats, type: CatTypes.favorite);
//         yield FavoriteCatLoadedState(catList: cats, page: page);
//       } else {
//         yield FavoriteCatEmptyState();
//       }
//     } catch (e) {
//       List<CatModel>? cats =
//           await repository.getCatLocal(type: CatTypes.favorite);
//       if (cats == null) {
//         yield FavoriteCatErrorState(message: 'Error fatching data!');
//       } else {
//         yield FavoriteCatLoadedState(catList: cats);
//       }
//     }
//   }

//   Stream<CatState> _mapFavoriteAddCatToState(CatEvent event) async* {
//     final eventData = (event as CatAddToFavoriteEvent);
//     final stateData = (state as FavoriteCatLoadedState);
//     final response =
//         await repository.addToFavorite(eventData.catId, eventData.userId);

//     if (response['message'] == 'SUCCESS') {
//       List<CatModel> catList = stateData.catList
//           .map((cat) => cat.id != eventData.catId
//               ? cat
//               : CatModel(
//                   id: cat.id,
//                   image: cat.image,
//                   fact: cat.fact,
//                   isFavorite: true,
//                   favoriteId: response['id'],
//                 ))
//           .toList();

//       yield FavoriteCatLoadedState(catList: catList, page: stateData.page);
//     }
//   }

//   Stream<CatState> _mapFavoriteCatRemoveToState(CatEvent event) async* {
//     final stateData = (state as FavoriteCatLoadedState);
//     final eventData = (event as CatRemoveFromFavoritesEvent);

//     final response = await repository.removeFromFavorite(eventData.favoriteId);

//     if (response['message'] == 'SUCCESS') {
//       List<CatModel> catList = stateData.catList
//           .map((cat) => cat.favoriteId != eventData.favoriteId
//               ? cat
//               : CatModel(
//                   id: cat.id,
//                   image: cat.image,
//                   fact: cat.fact,
//                   isFavorite: false,
//                   favoriteId: null,
//                 ))
//           .toList();

//       bool isEmpty = true;

//       for (int i = 0; i < catList.length; i++) {
//         if (catList[i].favoriteId != null) {
//           isEmpty = false;
//           break;
//         }
//       }

//       if (isEmpty) {
//         yield FavoriteCatEmptyState();
//       } else {
//         yield FavoriteCatLoadedState(catList: catList, page: stateData.page);
//       }
//     }
//   }
// }
