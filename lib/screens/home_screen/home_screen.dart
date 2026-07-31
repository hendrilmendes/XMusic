import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:orbit_music/generated/l10n.dart';
import 'package:orbit_music/screens/home_screen/card.dart';
import 'package:orbit_music/screens/home_screen/search_screen/search_screen.dart';
import 'package:orbit_music/screens/home_screen/section_item.dart';
import 'package:orbit_music/utils/adaptive_widgets/adaptive_widgets.dart';
import 'package:orbit_music/ytmusic/ytmusic.dart';
import 'package:orbit_music/widgets/screen_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final YTMusic ytMusic = GetIt.I<YTMusic>();
  late PageController _pageController;
  Timer? _autoScrollTimer;
  late ScrollController _scrollController;

  List<dynamic> chips = [];
  List<dynamic> sections = [];
  List<dynamic> highlights = [];
  String? continuation;
  bool initialLoading = true;
  bool nextLoading = false;
  int _currentHighlightPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(viewportFraction: 0.9)
      ..addListener(() {
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
    _scrollController.dispose();
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
        ).showSnackBar(SnackBar(content: Text(S.of(context).Error_Loading_Data)));
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
        ).showSnackBar(SnackBar(content: Text(S.of(context).Error_Loading_More)));
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
              final highlight = Map<String, dynamic>.from(highlights[index]);
              final thumbs = highlight['thumbnails'] as List<dynamic>?;
              final imageUrl = thumbs != null && thumbs.isNotEmpty
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
      Navigator.of(
        context,
      ).push(AdaptivePageRoute.create((_) => SearchScreen(query: title)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).Could_Not_Search_Song)),
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
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return ActionChip(
            label: Text(chip['title'] ?? ''),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide.none,
            ),
            onPressed: () => context.go('/chip', extra: chip),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: null,
      body: SafeArea(
        child: initialLoading
            ? const Center(child: AdaptiveProgressRing())
            : RefreshIndicator(
                onRefresh: _loadInitialData,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent * 0.8) {
                      _loadMoreData();
                      return true;
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScreenHeader(title: S.of(context).Home),
                            _buildHighlights(),
                            const SizedBox(height: 24),
                            _buildChipsRow(),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount:
                                  sections.length + (nextLoading ? 1 : 0),
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
                          ],
                        ),
                      ),
                    ),
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
              color: currentIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }
}
