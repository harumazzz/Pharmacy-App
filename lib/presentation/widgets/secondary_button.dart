import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.onPressed != null
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.transparent,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                onTapDown: widget.onPressed != null
                    ? (_) {
                        setState(() {});
                        _animationController.forward();
                      }
                    : null,
                onTapUp: widget.onPressed != null
                    ? (_) {
                        setState(() {});
                        _animationController.reverse();
                      }
                    : null,
                onTapCancel: widget.onPressed != null
                    ? () {
                        setState(() {});
                        _animationController.reverse();
                      }
                    : null,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.onPressed != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey[400],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.onPressed != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
