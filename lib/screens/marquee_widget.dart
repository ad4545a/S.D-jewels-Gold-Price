import 'package:flutter/material.dart';

// Custom Marquee Widget
class MarqueeWidget extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double speed;

  const MarqueeWidget({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 16),
    this.speed = 50.0,
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
     // Simple continuous scroll
     // Note: A true robust marquee handles infinite looping complexly.
     // For simplicity/reliability without packages, we scroll to end then jump back.
     
     if(!mounted) return;
     try {
       double maxScroll = _scrollController.position.maxScrollExtent;
       double currentScroll = _scrollController.position.pixels;
       double durationSeconds = (maxScroll - currentScroll) / widget.speed;
       
       if (durationSeconds <= 0) {
         // text fits
         return; 
       }

       await _scrollController.animateTo(
         maxScroll,
         duration: Duration(seconds: durationSeconds.toInt()),
         curve: Curves.linear,
       );
       
       if(!mounted) return;
       _scrollController.jumpTo(0.0);
       _startScrolling();
     } catch (e) {
       // Ignore scroll errors (e.g. detached)
     }
  }

  @override 
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10), // start padding
        // Render text twice with spacing to allow smoother loop if needed, 
        // but for jump method, single text + large padding is okay.
        child: Text(
          // Repeat text multiple times to ensure it overflows screen width
          "${widget.text}          " * 10, 
          style: widget.style,
        ),
      ),
    );
  }
}
