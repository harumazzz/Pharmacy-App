import 'package:flutter/material.dart';
import '../../data/models/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'thuốc kê đơn':
      case 'prescription':
        return Icons.medical_services;
      case 'thuốc không kê đơn':
      case 'otc':
        return Icons.local_pharmacy;
      case 'chăm sóc sức khỏe':
      case 'healthcare':
        return Icons.health_and_safety;
      case 'vitamin':
      case 'thực phẩm chức năng':
        return Icons.local_drink;
      case 'chăm sóc cá nhân':
      case 'personal care':
        return Icons.face;
      case 'thiết bị y tế':
      case 'medical devices':
        return Icons.medical_information;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.onTap != null ? _onTapDown : null,
            onTapUp: widget.onTap != null ? _onTapUp : null,
            onTapCancel: widget.onTap != null ? _onTapCancel : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    Colors.white,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.15),
                    blurRadius: _shadowAnimation.value,
                    offset: Offset(0, _isPressed ? 2 : 4),
                    spreadRadius: _isPressed ? 0 : 1,
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          _getCategoryIcon(widget.category.name),
                          size: 28,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Flexible(
                        child: Text(
                          widget.category.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
