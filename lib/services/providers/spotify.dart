import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpotifyService {
  static const String _clientId = '8eff248a586a4650a74dfc6b2b8fdebe';
  static const String _redirectUrl = 'xmusic://spotify/auth';
  static String _accessToken = '';
  static String _codeVerifier = '';
  final storage = FlutterSecureStorage();

  Future<void> _loadToken() async {
    _accessToken = await storage.read(key: 'access_token') ?? '';
    final refresh = await storage.read(key: 'refresh_token') ?? '';
    if (kDebugMode) {
      print('🔍 Token carregado: $_accessToken');
      print('🔍 Refresh token carregado: $refresh');
    }
  }

  Future<void> authenticate() async {
    try {
      await _loadToken();

      if (_accessToken.isEmpty) {
        _codeVerifier = _generateCodeVerifier();
        final codeChallenge = _generateCodeChallenge(_codeVerifier);

        final url = Uri.parse(
          'https://accounts.spotify.com/authorize?'
          'response_type=code&'
          'client_id=$_clientId&'
          'scope=playlist-read-private%20playlist-read-collaborative%20playlist-read-public&'
          'redirect_uri=${Uri.encodeComponent(_redirectUrl)}&'
          'code_challenge_method=S256&'
          'code_challenge=$codeChallenge&'
          'show_dialog=true',
        );

        if (kDebugMode) {
          print('🔑 Auth URL: $url');
        }

        final result = await FlutterWebAuth2.authenticate(
          url: url.toString(),
          callbackUrlScheme: 'xmusic',
        ).timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            throw Exception('Tempo de login excedido');
          },
        );

        final code = Uri.parse(result).queryParameters['code'];
        if (code == null) {
          if (kDebugMode) {
            print('Código não recebido da URL');
          }
          throw Exception('Código não recebido');
        } else {
          if (kDebugMode) {
            print('Código recebido: $code');
          }
        }

        await _getTokens(code);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro na autenticação: ${e.toString()}');
      }
      rethrow;
    }
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (i) => random.nextInt(256));
    return base64UrlEncode(
      values,
    ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
  }

  String _generateCodeChallenge(String verifier) {
    return base64UrlEncode(
      sha256.convert(utf8.encode(verifier)).bytes,
    ).replaceAll('=', '');
  }

  Future<void> _getTokens(String code) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': _clientId,
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': _redirectUrl,
        'code_verifier': _codeVerifier,
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      _accessToken = body['access_token'];
      final refreshToken = body['refresh_token'];

      if (kDebugMode) print('Tokens recebidos: $body');

      // Armazenar os tokens de forma segura
      await storage.write(key: 'access_token', value: _accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);

      final savedAccess = await storage.read(key: 'access_token');
      final savedRefresh = await storage.read(key: 'refresh_token');
      if (kDebugMode) {
        print('💾 access_token armazenado: $savedAccess');
        print('💾 refresh_token armazenado: $savedRefresh');
      }
    } else {
      if (kDebugMode) print('Erro ao obter tokens: ${response.body}');
      throw Exception('Erro ao obter tokens: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> importPlaylist(String playlistId) async {
    try {
      // Certifique-se de que o token de acesso está carregado corretamente
      if (_accessToken.isEmpty) {
        await _refreshToken();
        if (_accessToken.isEmpty) throw Exception('Autenticação falhou');
      }

      // Verificar se ainda está vazio após a autenticação
      if (_accessToken.isEmpty) throw Exception('Autenticação falhou');

      final uri = Uri.parse(
        'https://api.spotify.com/v1/playlists/${_sanitizePlaylistId(playlistId)}',
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      // Debug detalhado
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return _parseSpotifyPlaylist(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Token expirado - Faça login novamente');
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na importação: $e');
      }
      rethrow;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) return;

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': _clientId,
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      _accessToken = jsonDecode(response.body)['access_token'];
      await storage.write(key: 'access_token', value: _accessToken);
    } else {
      throw Exception('Erro ao renovar token: ${response.body}');
    }
  }

  String _sanitizePlaylistId(String input) {
    // Remove URI completo se fornecido
    return input.replaceAll('spotify:playlist:', '');
  }

  Map<String, dynamic> _parseSpotifyPlaylist(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'title': data['name'],
      'description': data['description'] ?? '',
      'tracks':
          (data['tracks']['items'] as List).map((item) {
            final track = item['track'];
            return {
              'title': track?['name'] ?? 'Desconhecido',
              'artist':
                  (track?['artists'] as List?)
                      ?.map((a) => a['name'])
                      .join(', ') ??
                  '',
              'duration': track?['duration_ms'] ?? 0,
              'id': track?['id'] ?? '',
            };
          }).toList(),
      'thumbnail':
          data['images']?.isNotEmpty == true
              ? data['images'][0]['url']
              : 'https://example.com/placeholder.jpg',
    };
  }
}
