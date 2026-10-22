import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lolflix/services/tmdb_service.dart';
import 'package:lolflix/services/scrapers/animetsu/animetsu_scraper.dart';
import 'package:lolflix/services/scrapers/miruro/miruro_scraper.dart';
import 'package:lolflix/services/scrapers/animex/animex_scraper.dart';
import 'package:lolflix/services/streaming_service.dart';
import 'package:lolflix/services/watch_history_service.dart';
import 'package:lolflix/services/cache_service.dart';
import 'package:lolflix/services/scrapers/newtv/newtv_scraper.dart';
import 'package:lolflix/services/anilist_service.dart';
import 'package:lolflix/services/scrapers/streamflix/streamflix_scraper.dart';
import 'package:lolflix/services/scrapers/moviebox/moviebox_scraper.dart';
import 'package:lolflix/services/scrapers/castletv/castletv_scraper.dart';
import 'package:lolflix/services/scrapers/vidrock/vidrock_scraper.dart';
import 'package:lolflix/services/torrent/torrent_stream_service.dart';
import 'package:lolflix/services/anime_filler_service.dart';
import 'package:lolflix/services/dns_over_https_service.dart';
import 'package:lolflix/models/search_result.dart';

// Cache service provider
final cacheServiceProvider = Provider((ref) {
  final cache = CacheService();
  // Note: init() must be called before use, handled in main.dart
  return cache;
});

// Service Providers
final tmdbServiceProvider = Provider((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return TmdbService(cache);
});

final aniListServiceProvider = Provider((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return AniListService(cache);
});


// Streaming service provider (direct primary, embed fallback)
final miruroScraperProvider = Provider<MiruroScraperService>((ref) {
  return MiruroScraperService();
});

final animexScraperProvider = Provider<AnimexScraperService>((ref) {
  return AnimexScraperService();
});

final streamingServiceProvider = Provider<StreamingService>((ref) => StreamingService(
  tmdbService: ref.read(tmdbServiceProvider),
  animetsuScraper: ref.read(animetsuScraperProvider),
  netMirrorScraper: ref.read(netMirrorScraperProvider),
  miruroScraper: ref.read(miruroScraperProvider),
  animexScraper: ref.read(animexScraperProvider),
  streamFlixScraper: ref.read(streamFlixScraperProvider),
  movieBoxScraper: ref.read(movieBoxScraperProvider),
  castleTvScraper: ref.read(castleTvScraperProvider),
  vidRockScraper: ref.read(vidRockScraperProvider),
  torrentStreamService: ref.read(torrentStreamServiceProvider),
  ref: ref,
));

// Embedded rqbit torrent streaming (P2P anime). Single instance
// so the engine and active torrent are shared across the app.
final torrentStreamServiceProvider =
    Provider<TorrentStreamService>((ref) => TorrentStreamService(
      tmdbService: ref.read(tmdbServiceProvider),
    ));

final watchHistoryServiceProvider = Provider((ref) => WatchHistoryService());

final animeFillerServiceProvider = Provider<AnimeFillerService>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return AnimeFillerService(cache);
});

final animeFillerDataProvider =
    FutureProvider.family<AnimeFillerData, SearchResult>((ref, media) async {
  if (media.mediaType != 'anime') {
    return const AnimeFillerData();
  }
  return ref.watch(animeFillerServiceProvider).getFillerData(
        anilistId: media.id,
        title: media.title ?? media.name ?? '',
        malId: media.malId,
      );
});

final dnsOverHttpsServiceProvider = Provider<DnsOverHttpsService>((ref) {
  return DnsOverHttpsService();
});

