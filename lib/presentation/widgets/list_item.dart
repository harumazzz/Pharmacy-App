import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
  final Color? backgroundColor;

  const ListItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.showDivider = true,
    this.backgroundColor,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backgroundColorAnimation =
        ColorTween(
          begin: Colors.transparent,
          end: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColorAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                _backgroundColorAnimation.value ??
                Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: _isHovered && widget.onTap != null
                ? Border.all(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  onHover: widget.onTap != null ? _onHover : null,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                    child: Row(
                      children: [
                        // Leading widget
                        if (widget.leading != null) ...[
                          Container(
                            constraints: const BoxConstraints(minWidth: 40),
                            child: widget.leading!,
                          ),
                          const SizedBox(width: 12.0),
                        ],
                        // Title and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.title != null)
                                DefaultTextStyle(
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ) ??
                                      const TextStyle(),
                                  child: widget.title!,
                                ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 4.0),
                                DefaultTextStyle(
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ) ??
                                      const TextStyle(),
                                  child: widget.subtitle!,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Trailing widget
                        if (widget.trailing != null) ...[
                          const SizedBox(width: 12.0),
                          widget.trailing!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // Divider
              if (widget.showDivider)
                Container(
                  margin: const EdgeInsets.only(left: 56.0, right: 16.0),
                  height: 1,
                  color: Colors.grey[200],
                ),
            ],
          ),
        );
      },
    );
  }
}
