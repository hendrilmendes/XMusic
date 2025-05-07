import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xmusic/generated/l10n.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final userData = {
      'name': user.displayName ?? 'Nome não disponível',
      'email': user.email ?? 'E-mail não disponível',
      'photoUrl': user.photoURL ?? 'https://www.example.com/default-avatar.png',
    };

    final playlistsSnapshot = await FirebaseFirestore.instance
        .collection('playlists')
        .where('userId', isEqualTo: user.uid)
        .get();

    userData['playlistCount'] = playlistsSnapshot.docs.length.toString();

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).Account),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).Account),
              centerTitle: true,
            ),
            body: Center(child: Text('Erro ao carregar dados do usuário')),
          );
        }

        final userData = snapshot.data ?? {};

        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).Account),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: CachedNetworkImageProvider(userData['photoUrl']),
              ),
              const SizedBox(height: 16),
              Text(
                userData['name'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                userData['email'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.playlist_play),
                title: Text(S.of(context).Playlists),
                subtitle: Text('${userData['playlistCount']} ${S.of(context).Playlists}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navegar para a tela de playlists
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
