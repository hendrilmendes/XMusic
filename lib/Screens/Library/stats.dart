import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:xmusic/CustomWidgets/gradient_containers.dart';
import 'package:xmusic/l10n/app_localizations.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  int get songsPlayed => Hive.box('stats').length;
  Map get mostPlayed =>
      Hive.box('stats').get('mostPlayed', defaultValue: {}) as Map;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.stats),
          centerTitle: true,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        songsPlayed.toString(),
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.songsPlayed),
                    ],
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context)!.mostPlayedSong),
                      const SizedBox(height: 10),
                      Text(
                        mostPlayed['title']?.toString() ??
                            AppLocalizations.of(context)!.unknown,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
