
import 'package:logging/logging.dart';
import 'package:xmusic/APIs/api.dart';
import 'package:xmusic/Services/player_service.dart';

Future<void> createRadioItems({
  required List<String> stationNames,
  String stationType = 'entity',
  int count = 20,
}) async {
  Logger.root
      .info('Creating Radio Station of type $stationType with $stationNames');
  String stationId = '';
  final String? value = await SaavnAPI()
      .createRadio(names: stationNames, stationType: stationType);

  if (value == null) return;

  stationId = value;
  final List songsList = await SaavnAPI().getRadioSongs(
    stationId: stationId,
    count: count,
  );

  if (songsList.isEmpty) return;

  PlayerInvoke.init(
    songsList: songsList,
    index: 0,
    isOffline: false,
    shuffle: true,
  );
}
