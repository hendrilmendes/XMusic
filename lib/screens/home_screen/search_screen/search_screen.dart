import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../services/media_player.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../../../utils/bottom_modals.dart';
import '../../../ytmusic/ytmusic.dart';
import '../../../widgets/screen_header.dart';
import '../../browse_screen/browse_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    this.endpoint,
    this.isMore = false,
    this.query,
    super.key,
  });
  final Map<String, dynamic>? endpoint;
  final bool isMore;
  final String? query;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  bool initialLoading = false;
  bool nextLoading = false;
  List<Map<String, dynamic>> results = [];
  String? continuation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();

    if (widget.query != null) {
      _textEditingController.text = widget.query!;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onSubmit(widget.query!),
      );
    }

    if (widget.endpoint != null) {
      search(widget.endpoint!);
    }
  }

  Future<void> scrollListener() async {
    if (initialLoading || nextLoading || continuation == null) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await fetchNext();
    }
  }

  Future<void> onSubmit(String value) async {
    _focusNode.unfocus();
    setState(() {
      initialLoading = true;
    });
    if (Hive.box('SETTINGS').get('SEARCH_HISTORY', defaultValue: true)) {
      await Hive.box('SEARCH_HISTORY').delete(value.toLowerCase());
      await Hive.box('SEARCH_HISTORY').put(value.toLowerCase(), value);
    }
    Map response = await GetIt.I<YTMusic>().search(value);
    results = List<Map<String, dynamic>>.from(response['sections']);
    continuation = response['continuation'];
    setState(() {
      initialLoading = false;
    });
  }

  Future<void> fetchNext() async {
    if (continuation == null) return;
    setState(() {
      nextLoading = true;
    });
    Map response = await GetIt.I<YTMusic>().search(
      '',
      endpoint: widget.endpoint,
      additionalParams: continuation!,
    );
    results.addAll(List<Map<String, dynamic>>.from(response['sections']));
    continuation = response['continuation'];
    if (mounted) {
      setState(() {
        nextLoading = false;
      });
    }
  }

  Future<void> search(
    Map<String, dynamic> value, {
    String additionalParams = '',
  }) async {
    _textEditingController.value = value['query'];
    setState(() {
      initialLoading = true;
    });
    Map response = await GetIt.I<YTMusic>().search(
      '',
      endpoint: value,
      additionalParams: additionalParams,
    );
    results = List<Map<String, dynamic>>.from(response['sections']);
    continuation = response['continuation'];
    setState(() {
      initialLoading = false;
    });
  }

  Future<void> getSuggestions(String query) async {
    await GetIt.I<YTMusic>().getSearchSuggestions(query);
  }

  Widget _buildEmptyState() {
    final List<Map<String, dynamic>> categories = [
      {'title': 'Pop', 'color': Colors.pinkAccent},
      {'title': 'Hip-Hop', 'color': Colors.orange},
      {'title': 'Eletrônica', 'color': Colors.teal},
      {'title': 'Rock', 'color': Colors.redAccent},
      {'title': 'Sertanejo', 'color': Colors.amber},
      {'title': 'Funk', 'color': Colors.purpleAccent},
      {'title': 'Treino', 'color': Colors.blueAccent},
      {'title': 'Foco', 'color': Colors.indigo},
      {'title': 'Relax', 'color': Colors.lightBlue},
      {'title': 'K-Pop', 'color': Colors.pink},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            S.of(context).Browse_Categories,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () {
                _textEditingController.text = cat['title'];
                onSubmit(cat['title']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cat['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  cat['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width <= 400 &&
            Navigator.canPop(context))
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: AdaptiveBackButton(),
          ),
        Expanded(
          child: TypeAheadField(
            suggestionsCallback: (query) =>
                GetIt.I<YTMusic>().getSearchSuggestions(query),
            builder: (context, controller, focusNode) {
              return TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                onSubmitted: onSubmit,
                onChanged: (value) {
                  getSuggestions(value);
                },
                keyboardType: TextInputType.text,
                maxLines: 1,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: S.of(context).Search_xmusic,
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 17,
                  ),
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: 20,
                  ),
                  suffixIcon: _textEditingController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _textEditingController.clear();
                            });
                          },
                          child: Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            size: 18,
                          ),
                        )
                      : null,
                ),
              );
            },
            itemBuilder: (context, value) {
              if (value['type'] == 'TEXT') {
                return ListTile(
                  leading: value['isHistory'] != null
                      ? const Icon(CupertinoIcons.clock)
                      : const Icon(CupertinoIcons.search),
                  title: Text(
                    value['query'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    setState(() {
                      _textEditingController.text = value['query'];
                    });
                    onSubmit(value['query']);
                  },
                );
              }
              return SearchListTile(item: value);
            },
            onSelected: (value) => (),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: widget.endpoint != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const AdaptiveBackButton(),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.endpoint!['query'],
                          style: Theme.of(context).textTheme.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: initialLoading
            ? const Center(child: AdaptiveProgressRing())
            : SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.endpoint == null &&
                            results.isEmpty &&
                            _textEditingController.text.isEmpty)
                          ScreenHeader(title: S.of(context).Search),
                        if (widget.endpoint == null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildSearchBar(),
                          ),
                        if (results.isEmpty &&
                            _textEditingController.text.isEmpty)
                          _buildEmptyState(),
                        ...results.map((section) {
                          if (Platform.isWindows) {
                            return Center(
                              child: Adaptivecard(
                                borderRadius: BorderRadius.circular(8),
                                child: SearchSectionItem(
                                  section: section,
                                  isMore: widget.isMore,
                                ),
                              ),
                            );
                          }
                          return SearchSectionItem(
                            section: section,
                            isMore: widget.isMore,
                          );
                        }),
                        if (nextLoading)
                          const Center(child: AdaptiveProgressRing()),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class SearchSectionItem extends StatelessWidget {
  const SearchSectionItem({
    required this.section,
    this.isMore = false,
    super.key,
  });
  final Map<String, dynamic> section;
  final bool isMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (section['title'] != null && !isMore)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    section['title'],
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (section['trailing']?['text'] != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        AdaptivePageRoute.create(
                          (context) => SearchScreen(
                            endpoint: section['trailing']['endpoint'],
                            isMore: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      section['trailing']['text'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ...section['contents'].map((item) {
          return SearchListTile(item: item);
        }),
      ],
    );
  }
}

class SearchListTile extends StatelessWidget {
  const SearchListTile({required this.item, super.key});
  final Map item;
  @override
  Widget build(BuildContext context) {
    return AdaptiveListTile(
      onSecondaryTap: () {
        if (item['videoId'] != null) {
          Modals.showSongBottomModal(context, item);
        } else if (item['endpoint'] != null) {
          Modals.showPlaylistBottomModal(context, item);
        }
      },
      onTap: () async {
        if (item['videoId'] != null) {
          await GetIt.I<MediaPlayer>().playSong(Map.from(item));
        } else if (item['endpoint'] != null && item['videoId'] == null) {
          Navigator.push(
            context,
            AdaptivePageRoute.create(
              (context) => BrowseScreen(endpoint: item['endpoint']),
            ),
          );
        }
      },
      onLongPress: () {
        if (item['videoId'] != null) {
          Modals.showSongBottomModal(context, item);
        } else if (item['endpoint'] != null) {
          Modals.showPlaylistBottomModal(context, item);
        }
      },
      dense: false,
      title: Text(
        item['title'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: item['subtitle'] != null
          ? Text(
              item['subtitle'],
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      leading: item['thumbnails'] != null && item['thumbnails'].isNotEmpty
          ? Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ['ARTIST', 'PROFILE'].contains(item['type']) ? 50 : 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ['ARTIST', 'PROFILE'].contains(item['type']) ? 50 : 6,
                ),
                child: CachedNetworkImage(
                  imageUrl: item['thumbnails'].first['url'],
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const SizedBox(width: 50, height: 50),
      trailing: item['videoId'] == null && item['endpoint'] != null
          ? Icon(
              CupertinoIcons.chevron_right,
              color: Theme.of(context).textTheme.bodySmall?.color,
              size: 18,
            )
          : null,
    );
  }
}
