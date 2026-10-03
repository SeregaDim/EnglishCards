import 'package:flutter/material.dart';
import '../models/flash_models.dart';
import '../widgets/category_tabs_bar.dart';
import 'cards_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<WordCategory> categories;
  const HomeScreen({super.key, required this.categories});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late List<WordCard> _visibleCards;

  @override
  void initState() {
    super.initState();
    _visibleCards = List.of(widget.categories[_selectedCategoryIndex].cards);
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _visibleCards = List.of(widget.categories[index].cards);
    });
  }

  void _shuffleCards() {
    setState(() => _visibleCards.shuffle());
  }

  void _openCard(WordCard tappedCard) {
    final realIndex = widget.categories[_selectedCategoryIndex].cards.indexOf(tappedCard);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CardsScreen(
          categories: widget.categories,
          categoryIndex: _selectedCategoryIndex,
          initialIndex: realIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.categories[_selectedCategoryIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF15151F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('English Cards',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Учите английский — по одной карточке',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.settings_outlined, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 14),
            CategoryTabsBar(
              categories: widget.categories.map((c) => c.title).toList(),
              selectedIndex: _selectedCategoryIndex,
              onSelected: _selectCategory,
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Stack(
                children: [
                  ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: _visibleCards.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final word = _visibleCards[index];
                      final isHighlighted = index == 0;
                      return _WordTile(
                        title: word.word,
                        highlighted: isHighlighted,
                        gradientColors: category.gradientColors,
                        onTap: () => _openCard(word),
                      );
                    },
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFF3B6FE0),
                      onPressed: _shuffleCards,
                      child: const Icon(Icons.shuffle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordTile extends StatelessWidget {
  final String title;
  final bool highlighted;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _WordTile({
    required this.title,
    required this.highlighted,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: highlighted ? LinearGradient(colors: gradientColors) : null,
          color: highlighted ? null : const Color(0xFF20202E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white, fontSize: 17, fontWeight: highlighted ? FontWeight.bold : FontWeight.w500)),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(highlighted ? 1 : 0.4)),
          ],
        ),
      ),
    );
  }
}
