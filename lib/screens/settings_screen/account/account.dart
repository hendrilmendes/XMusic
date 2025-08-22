import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xmusic/auth/auth.dart';
import 'package:xmusic/generated/l10n.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final user = await _authService.currentUser();
    if (user == null) return {};

    final Map<String, dynamic> userData = {
      'name': user.displayName ?? 'Nome não disponível',
      'email': user.email ?? 'E-mail não disponível',
      'photoUrl': user.photoURL ?? '',
    };

    final playlistsSnapshot = await FirebaseFirestore.instance
        .collection('playlists')
        .where('userId', isEqualTo: user.uid)
        .get();

    userData['playlistCount'] = playlistsSnapshot.docs.length;

    return userData;
  }

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Account),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "S.of(context).Logout",
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "S.of(context).Error_while_loading_data",
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          final userData = snapshot.data!;
          final photoUrl = userData['photoUrl'] as String;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    backgroundImage: photoUrl.isNotEmpty
                        ? CachedNetworkImageProvider(photoUrl)
                        : null,
                    child: photoUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData['name'],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userData['email'],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              Text(S.of(context).Saved, style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                child: ListTile(
                  leading: const Icon(Icons.playlist_play),
                  title: Text(S.of(context).Playlists),
                  trailing: Text(
                    userData['playlistCount'].toString(),
                    style: theme.textTheme.titleMedium,
                  ),
                  onTap: () {
                    // TODO: Navegar para a tela de playlists do usuário
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
