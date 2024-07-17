import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failures.dart';
import 'package:travel_app/features/trip/domain/entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getTrips();
  Future<void> addTrips(Trip trip);
  Future<void> deleteTrips(int index);
}
