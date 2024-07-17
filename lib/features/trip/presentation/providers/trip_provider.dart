import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:travel_app/features/trip/data/datasources/trip_local_datasources.dart';
import 'package:travel_app/features/trip/data/models/trip_model.dart';
import 'package:travel_app/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:travel_app/features/trip/domain/entities/trip.dart';
import 'package:travel_app/features/trip/domain/repositories/trip_repository.dart';
import 'package:travel_app/features/trip/domain/usecases/add_trips.dart';
import 'package:travel_app/features/trip/domain/usecases/delete_trips.dart';
import 'package:travel_app/features/trip/domain/usecases/get_trips.dart';

final tripLocalDataSourceProvider = Provider<TripLocalDataSources>(
  (ref) {
    final Box<TripModel> tripBox = Hive.box('trips');
    return TripLocalDataSources(tripBox);
  },
);

final tripRepositoryProvider = Provider<TripRepository>(
  (ref) {
    final localDataSource = ref.read(tripLocalDataSourceProvider);
    return TripRepositoryImpl(localDataSource);
  },
);

final addTripProvider = Provider<AddTrips>(
  (ref) {
    final repository = ref.read(tripRepositoryProvider);
    return AddTrips(repository);
  },
);

final getTripProvider = Provider<GetTrips>(
  (ref) {
    final repository = ref.read(tripRepositoryProvider);
    return GetTrips(repository);
  },
);

final deleteTripProvider = Provider<DeleteTrips>(
  (ref) {
    final repository = ref.read(tripRepositoryProvider);
    return DeleteTrips(repository);
  },
);

final tripListNotifierProvider =
    StateNotifierProvider<TripListNotifier, List<Trip>>((ref) {
  final getTrips = ref.read(getTripProvider);
  final addTrips = ref.read(addTripProvider);
  final deleteTrips = ref.read(deleteTripProvider);

  return TripListNotifier(getTrips, addTrips, deleteTrips);
});

class TripListNotifier extends StateNotifier<List<Trip>> {
  final GetTrips _getTrips;
  final AddTrips _addTrips;
  final DeleteTrips _deleteTrips;

  TripListNotifier(this._getTrips, this._addTrips, this._deleteTrips)
      : super([]);

  Future<void> addNewTrip(Trip trip) async {
    await _addTrips(trip);
  }

  Future<void> removeTrip(int tripId) async {
    await _deleteTrips(tripId);
  }

  Future<void> loadTrips() async {
    final tripsOrFailure = await _getTrips();
    tripsOrFailure.fold((error) => state = [], (trips) => state = trips);
  }
}
