import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_app/features/trip/domain/entities/trip.dart';
import 'package:travel_app/features/trip/presentation/providers/trip_provider.dart';

class AddTripScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'City 1');
  final _descController = TextEditingController(text: 'Best city ever');
  final _locationController = TextEditingController(text: 'Paris');
  final _pictureController = TextEditingController(
    text:
        'https://media.istockphoto.com/id/1345426734/photo/eiffel-tower-paris-river-seine-sunset-twilight-france.jpg?s=612x612&w=0&k=20&c=I5rAH5d_-Yyag8F0CKzk9vzMr_1rgkAASGTE11YMh9A=',
  );
  List<String> pictures = [];

  AddTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'title',
            ),
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
            ),
          ),
          TextFormField(
            controller: _pictureController,
            decoration: const InputDecoration(
              labelText: 'Photo',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              pictures.add(_pictureController.text);
              if (_formKey.currentState!.validate()) {
                final newTrip = Trip(
                  title: _titleController.text,
                  description: _descController.text,
                  date: DateTime.now(),
                  location: _locationController.text,
                  photos: pictures,
                );
                ref.read(tripListNotifierProvider.notifier).addNewTrip(newTrip);
                ref.read(tripListNotifierProvider.notifier).loadTrips();
              }
            },
            child: const Text(
              'Add Trip',
            ),
          ),
        ],
      ),
    );
  }
}
