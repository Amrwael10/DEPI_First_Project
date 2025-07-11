import 'dart:io';
import 'graph.dart';
import 'right_stations.dart';

void main(){
  // Step 1 : enter the data
  print('Hi Sir , Welcome to the metro station 🤗');
  print('Please , enter ur start');
  final start = validateStation(stdin.readLineSync() ?? '');
  print('good , and what is ur arrival ?');
  final arrival = validateStation(stdin.readLineSync() ?? '');

  // Check if the start or the arrival are wrong names
  if(start == null || arrival == null){
    print('sorry, Enter a right station name for the start and the arrival');
    return;
  }

  // Step 2: Build the graph and search (Algorithm)
  final graph = buildMetroGraph();
  final route = findShortestPath(graph, start, arrival);

  // Step 3 : Output results
  final stopCount = route.length - 1;
  final time = stopCount * 2;
  var ticketPrice = 5;
  if(stopCount > 23){
    ticketPrice = 20;
  }
  else if(stopCount == 23){
    ticketPrice = 15;
  }
  else if(stopCount >= 16 && stopCount < 23){
      ticketPrice = 10;
    }
  else if(stopCount >= 9 && stopCount < 16){
    ticketPrice = 8;
  }

  print('The number of stations you will visit is $stopCount');
  if(time < 60){
    print('it will take $time mins');
  }
  else{
    final hours = time ~/ 60;
    final minutes = time % 60;
    print('it will take $hours hours and $minutes mins');
  }
  print('ticket price is $ticketPrice');
  print('direction => ${route.last}');
  print('The stations you will visit are : ');
  if (route.isNotEmpty) {
    printRouteWithTransfers(route);
  } else {
    print("No route found.");
  }
}