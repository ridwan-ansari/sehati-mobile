class YoutubeUtils {
  static String extractVideoId(String url) {
    final uri = Uri.parse(url);

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    return uri.pathSegments.last;
  }
}
