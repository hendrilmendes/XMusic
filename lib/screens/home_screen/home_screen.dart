import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:xmusic/generated/l10n.dart';
import 'package:xmusic/screens/home_screen/card.dart';
import 'package:xmusic/screens/home_screen/search_screen/search_screen.dart';
import 'package:xmusic/screens/home_screen/section_item.dart';
import 'package:xmusic/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:xmusic/ytmusic/ytmusic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final YTMusic ytMusic = GetIt.I<YTMusic>();
  late PageController _pageController;
  Timer? _autoScrollTimer;

  List chips = [];
  List sections = [];
  List highlights = [];
  String? continuation;
  bool initialLoading = true;
  bool nextLoading = false;
  int _currentHighlightPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9)..addListener(() {
      final page = (_pageController.page ?? 0).round();
      if (_currentHighlightPage != page) {
        setState(() => _currentHighlightPage = page);
      }
    });

    _startAutoScroll();
    _loadInitialData();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_pageController.hasClients) {
        timer.cancel();
        return;
      }
      if (highlights.isEmpty) return;

      final nextPage = (_currentHighlightPage + 1) % highlights.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final data = await ytMusic.browse();
      final allSections = data['sections'] as List;
      if (allSections.isNotEmpty && allSections.first['contents'] != null) {
        highlights = (allSections.first['contents'] as List).take(3).toList();
        sections = allSections.skip(1).toList();
      } else {
        highlights = [];
        sections = allSections;
      }
      setState(() {
        chips = data['chips'] ?? [];
        continuation = data['continuation'];
        initialLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => initialLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erro ao carregar dados")));
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (nextLoading || continuation == null) return;
    setState(() => nextLoading = true);
    try {
      final data = await ytMusic.browseContinuation(
        additionalParams: continuation!,
      );
      if (mounted) {
        setState(() {
          sections.addAll(data['sections'] ?? []);
          continuation = data['continuation'];
          nextLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => nextLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erro ao carregar mais")));
      }
    }
  }

  Widget _buildHighlights() {
    if (highlights.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: highlights.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final highlight = highlights[index] as Map<String, dynamic>;
              final thumbs = highlight['thumbnails'] as List<dynamic>?;
              final imageUrl =
                  thumbs != null && thumbs.isNotEmpty
                      ? (thumbs.last['url'] as String)
                      : '';
              return HighlightCard(
                imageUrl: imageUrl,
                videoId: highlight['videoId'] as String?,
                title: highlight['title'] ?? '',
                subtitle: highlight['subtitle'] ?? '',
                onTap: () => _handleHighlightTap(highlight),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _PageIndicator(
          count: highlights.length,
          currentIndex: _currentHighlightPage,
        ),
      ],
    );
  }

  void _handleHighlightTap(Map<String, dynamic> highlight) {
    final title = highlight['title'] as String? ?? '';
    if (title.isNotEmpty) {
      Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (context) => SearchScreen(query: title)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível buscar a música.')),
      );
    }
  }

  Widget _buildChipsRow() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return ActionChip(
            label: Text(chip['title'] ?? ''),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            onPressed: () => context.go('/chip', extra: chip),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).Home),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:
          initialLoading
              ? const Center(child: AdaptiveProgressRing())
              : RefreshIndicator(
                onRefresh: () async => _loadInitialData(),
                child: NestedScrollView(
                  headerSliverBuilder:
                      (context, innerBoxScrolled) => [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 16, bottom: 24),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildHighlights(),
                                const SizedBox(height: 24),
                                _buildChipsRow(),
                              ],
                            ),
                          ),
                        ),
                      ],
                  body: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent * 0.8) {
                        _loadMoreData();
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: sections.length + (nextLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < sections.length) {
                          return SectionItem(section: sections[index]);
                        }
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: AdaptiveProgressRing()),
                        );
                      },
                    ),
                  ),
                ),
              ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          return Container(
            width: currentIndex == index ? 16 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  currentIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }
}
