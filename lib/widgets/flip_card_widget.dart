import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/flash_models.dart';

class FlipCardWidget extends StatefulWidget {
  final WordCard card;
  final List<Color> gradientColors;

  const FlipCardWidget({super.key, required this.card, required this.gradientColors});

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isFront = true;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _setupTts();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  void _flip() {
    if (_controller.isAnimating) return;
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final angle = _controller.value * math.pi;
          final matrix = Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle);
          final showBack = angle > math.pi / 2;

          Widget content = showBack ? _buildBack() : _buildFront();
          if (showBack) {
            content = Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(math.pi),
              child: content,
            );
          }
          return Transform(alignment: Alignment.center, transform: matrix, child: content);
        },
      ),
    );
  }

  Widget _buildFront() {
    return _CardShell(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: widget.gradientColors,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.card.word,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Text('[ ${widget.card.transcription} ]',
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.85))),
          const SizedBox(height: 20),
          _speakerButton(Colors.white, textToSpeak: widget.card.word),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _CardShell(
      gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.card.translation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            Container(height: 1, width: 56, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text(widget.card.exampleEn,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(widget.card.exampleRu,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            _speakerButton(Colors.grey.shade700, textToSpeak: widget.card.exampleEn),
          ],
        ),
      ),
    );
  }

  Widget _speakerButton(Color color, {required String textToSpeak}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _speak(textToSpeak),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(Icons.volume_up_rounded, color: color, size: 24),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Gradient gradient;
  final Widget child;

  const _CardShell({required this.gradient, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: child,
    );
  }
}
