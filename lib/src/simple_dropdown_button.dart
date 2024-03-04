import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_utils/simple_utils.dart';

///
class SimpleDropdownButton<T> extends StatefulWidget {
  ///
  const SimpleDropdownButton({
    required this.items,
    this.menuItemBuilder,
    this.builder,
    this.onSelected,
    this.isSelected,
    this.disabled = false,
    this.onPressed,
    super.key,
  });

  ///
  final List<T> items;

  ///
  final Widget Function(BuildContext context, T item)? menuItemBuilder;

  ///
  final ValueSetter<T>? onSelected;

  ///
  final bool Function(T item)? isSelected;

  ///
  final Widget Function(SimpleDropdownButtonState<T> state)? builder;

  ///
  final bool disabled;

  ///
  final VoidCallback? onPressed;

  @override
  State<SimpleDropdownButton<T>> createState() =>
      SimpleDropdownButtonState<T>();
}

///
class SimpleDropdownButtonState<T> extends State<SimpleDropdownButton<T>> {
  late final _menuFocusNode = FocusNode();
  final MenuController _controller = MenuController();
  bool _internal = false;

  ///
  late final focusNode = FocusNode()..addListener(_onFieldFocus);

  ///
  void onPressed() {
    widget.onPressed?.call();
    _controller.isOpen ? _controller.close() : _controller.open();
  }

  void _onFieldFocus() {
    if (!_internal && focusNode.hasFocus) {
      _controller.open();
    } else {
      _internal = _controller.isOpen;
    }
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    final focusScope = FocusScope.of(context);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.enter:
        onPressed();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.arrowUp:
        focusScope.previousFocus();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.arrowDown:
        focusScope.nextFocus();
        return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    focusNode
      ..removeListener(_onFieldFocus)
      ..dispose();
    _menuFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKey: _onKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MenuAnchor(
            controller: _controller,
            onOpen: _menuFocusNode.requestFocus,
            onClose: () {
              _internal = true;
            },
            style: const MenuStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
            ),
            menuChildren: widget.items.mapIndexed((index, e) {
              final selected = widget.isSelected?.call(e) ?? false;
              return SizedBox(
                width: constraints.maxWidth,
                child: MenuItemButton(
                  onPressed: () {
                    widget.onSelected?.call(e);
                    FocusScope.of(context).nextFocus();
                  },
                  focusNode: index == 0 ? _menuFocusNode : null,
                  style: MenuItemButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: selected
                        ? Theme.of(context).focusColor
                        : Colors.transparent,
                  ),
                  child: widget.menuItemBuilder?.call(context, e) ?? Text('$e'),
                ),
              );
            }).toList(),
            builder: (context, controller, child) {
              if (widget.disabled) return child!;
              return Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onPressed,
                  child: child,
                ),
              );
            },
            child: widget.builder?.call(this) ?? const Text('Select'),
          );
        },
      ),
    );
  }
}
