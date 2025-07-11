import 'dart:io';
import 'package:string_similarity/string_similarity.dart';
import 'lines_stations_data.dart';

// make all stations in lower case
final allStations = {...line1, ...line2, ...line_three_rod, ...list_three_cairo}.map((s) => s.toLowerCase()).toSet();

// Function to suggest the closest station if not found
String? validateStation(String input) {
  final query = input.toLowerCase();

  // Check if the (query==station name) is in any line (allStations)
  if (allStations.contains(query)) return query;

  // Find the most similar station
  final bestMatch = StringSimilarity.findBestMatch(query, allStations.toList());
  final suggestion = bestMatch.bestMatch.target;
  final rating = bestMatch.bestMatch.rating!;

  if (rating > 0.5) {
    print('Did you mean "$suggestion"? (y/n): ');
    final answer = stdin.readLineSync()?.trim().toLowerCase();
    if (answer == 'y') return suggestion;
  }

  print('Station "$input" not found.');
  return null;
}
