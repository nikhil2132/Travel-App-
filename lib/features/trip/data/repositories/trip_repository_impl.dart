import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failures.dart';
import 'package:travel_app/features/trip/data/datasources/trip_local_datasources.dart';
import 'package:travel_app/features/trip/data/models/trip_model.dart';
import 'package:travel_app/features/trip/domain/entities/trip.dart';
import 'package:travel_app/features/trip/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripLocalDataSources localDataSources;

  TripRepositoryImpl(
    this.localDataSources,
  );

  @override
  Future<void> addTrips(Trip trip) async {
    final tripModel = TripModel.fromEntity(trip);
    localDataSources.addTrip(tripModel);
  }

  @override
  Future<void> deleteTrips(int index) async {
    localDataSources.deleteTrip(index);
  }

  @override
  Future<Either<Failure, List<Trip>>> getTrips() async {
    try {
      final tripModels = localDataSources.getTrips();
      List<Trip> res = tripModels.map((model) => model.toEntity()).toList();
      return Right(res);
    } catch (e) {
      return Left(SomeSpecificError(e.toString()));
    }
  }
}
