import 'package:flutter/material.dart';
import '../models/flash_models.dart';
import '../widgets/category_tabs_bar.dart';
import '../widgets/flip_card_widget.dart';

class CardsScreen extends StatefulWidget {
  final List<WordCategory> categories;
  final int categoryIndex;
  final int initialIndex;

  const CardsScreen({
    super.key,
    required this.categories,
    required this.categoryIndex,
    required this.initialIndex,
  });

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  late int _categoryIndex;
  late int _currentIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _categoryIndex = widget.categoryIndex;
    _currentIndex = widget.initialIndex;
    // ВАЖНО: viewportFraction уменьшена с дефолтных 1.0 до 0.88.
    // Дело в том, что PageView по умолчанию требует протянуть палец
    // больше чем на 50% ширины страницы (без быстрого флика), чтобы
    // страница переключилась. Раз ширина страницы = ширина экрана,
    // получается "нужно провести почти через весь экран".
    // Уменьшая viewportFraction, мы уменьшаем саму ширину "страницы"
    // в пикселях — тот же порог 50% теперь требует заметно меньшего
    // расстояния свайпа. Бонус: видно краешек соседней карточки.
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.88,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectCategory(int index) {
    setState(() {
      _categoryIndex = index;
      _currentIndex = 0;
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.categories[_categoryIndex];
    final cards = category.cards;

    return Scaffold(
      backgroundColor: const Color(0xFF15151F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 20, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      category.title,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text('${_currentIndex + 1} / ${cards.length}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            CategoryTabsBar(
              categories: widget.categories.map((c) => c.title).toList(),
              selectedIndex: _categoryIndex,
              onSelected: _selectCategory,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  // Внутренний отступ уменьшен с 24 до 12, чтобы компенсировать
                  // сужение страницы через viewportFraction и сохранить
                  // прежнюю визуальную ширину самой карточки
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: FlipCardWidget(
                        key: ValueKey('${category.title}_${cards[index].word}'),
                        card: cards[index],
                        gradientColors: category.gradientColors,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            const Column(
              children: [
                Icon(Icons.sync, color: Colors.grey, size: 20),
                SizedBox(height: 4),
                Text('Нажмите на карточку, чтобы перевернуть', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
