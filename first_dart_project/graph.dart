import 'dart:collection';
import 'lines_stations_data.dart';
Map<String, List<String>> stationToLines = {};

// Build a unified graph from all metro lines
Map<String, List<String>> buildMetroGraph() {
  final Map<String, List<String>> graph = {};

  void connectLine(List<String> line , String lineName) {
    for (int i = 0; i < line.length; i++) {
      final station = line[i].toLowerCase();
      graph.putIfAbsent(station, () => []);

      // connect every station with the prev and the next one (bidirectional way)
      if (i > 0) {
        final prev = line[i - 1].toLowerCase();
        graph[station]!.add(prev);
      }
      if (i < line.length - 1) {
        final next = line[i + 1].toLowerCase();
        graph[station]!.add(next);
      }

      // Track which line(s) this station is part of
      stationToLines.putIfAbsent(station, () => []);
      if (!stationToLines[station]!.contains(lineName)) {
        stationToLines[station]!.add(lineName);
      }
    }
  }

  // implement the map
  connectLine(line1 , "Line 1");
  connectLine(line2 , "Line 2");
  connectLine(line_three_rod , "Line 3 (Rod el Frag)");
  connectLine(list_three_cairo, "Line 3 (Cairo Uni)");

  return graph;
}

// BFS Algo to find the shortest path between two stations
List<String> findShortestPath(Map<String, List<String>> graph, String start, String end) {
  // first station to be visited => first station to be left
  final visited = <String>{};
  final queue = Queue<List<String>>();
  queue.add([start]);

  while (queue.isNotEmpty) {
    final path = queue.removeFirst();
    final current = path.last;

    if (current == end) return path;

    if (!visited.contains(current)) {
      visited.add(current);
      for (final neighbor in graph[current] ?? []) {
        queue.add([...path, neighbor]);
      }
    }
  }
  return [];
}

void printRouteWithTransfers(List<String> path) {
  String? previousLine;

  for (int i = 0; i < path.length; i++) {
    final station = path[i];
    final lines = stationToLines[station] ?? [];

    // Determine the line used for this station
    String? currentLine;
    if (previousLine != null && lines.contains(previousLine)) {
      currentLine = previousLine;
    }
    else if (lines.length == 1) {
      currentLine = lines.first;
    }
    else {
      if (i > 0) {
        final prevLines = stationToLines[path[i - 1]] ?? [];
        currentLine = lines.firstWhere(
              (line) => prevLines.contains(line),
          orElse: () => lines.first,
        );
      } else {
        currentLine = lines.first;
      }
    }

    // Detect transfer
    if (previousLine != null && previousLine != currentLine) {
      final prevStation = path[i - 1];
      print('↪️ Transfer at $prevStation from $previousLine to $currentLine');
    }

    // Print the station
    print('${i + 1}. ${station[0].toUpperCase()}${station.substring(1)}');
    previousLine = currentLine;
  }
}


