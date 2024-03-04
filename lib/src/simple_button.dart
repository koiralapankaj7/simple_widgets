import 'package:flutter/material.dart';

///
class SimpleButton extends StatelessWidget {
  ///
  SimpleButton.text({
    required Widget child,
    VoidCallback? onPressed,
    super.key,
  }) : _child = TextButton(
          onPressed: onPressed,
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(18)),
          ),
          child: child,
        );

  ///
  SimpleButton.filled({
    required Widget child,
    VoidCallback? onPressed,
    bool borderOnDisabled = false,
    super.key,
  }) : _child = Builder(
          builder: (context) {
            return FilledButton(
              onPressed: onPressed,
              style: (FilledButtonTheme.of(context).style ??
                      FilledButton.styleFrom())
                  .copyWith(
                padding: const MaterialStatePropertyAll(EdgeInsets.all(18)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                side: borderOnDisabled
                    ? MaterialStateProperty.resolveWith((states) {
                        return states.contains(MaterialState.disabled)
                            ? BorderSide(
                                color: Theme.of(context).disabledColor,
                              )
                            : null;
                      })
                    : null,
              ),
              child: child,
            );
          },
        );

  ///
  SimpleButton.outlined({
    required Widget child,
    VoidCallback? onPressed,
    super.key,
  }) : _child = Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return OutlinedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                padding: const MaterialStatePropertyAll(EdgeInsets.all(18)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                side: MaterialStateProperty.resolveWith((states) {
                  return BorderSide(
                    color: states.contains(MaterialState.disabled)
                        ? theme.disabledColor
                        : theme.primaryColor,
                  );
                }),
              ),
              child: child,
            );
          },
        );

  ///
  SimpleButton.filledIcon({
    required Widget icon,
    required Widget label,
    VoidCallback? onPressed,
    super.key,
  }) : _child = Builder(
          builder: (context) {
            return FilledButton.icon(
              onPressed: onPressed,
              icon: IconTheme.merge(
                data: const IconThemeData(size: 18),
                child: icon,
              ),
              label: Padding(
                padding: const EdgeInsets.only(left: 4, right: 8),
                child: label,
              ),
              style: (FilledButtonTheme.of(context).style ??
                      FilledButton.styleFrom())
                  .copyWith(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          },
        );

  ///
  SimpleButton.outlinedIcon({
    required Widget icon,
    required Widget label,
    VoidCallback? onPressed,
    super.key,
  }) : _child = Builder(
          builder: (context) {
            final theme = Theme.of(context);
            final style = OutlinedButtonTheme.of(context).style ??
                OutlinedButton.styleFrom();
            return OutlinedButton.icon(
              onPressed: onPressed,
              icon: IconTheme.merge(
                data: const IconThemeData(size: 18),
                child: icon,
              ),
              label: Padding(
                padding: const EdgeInsets.only(left: 4, right: 8),
                child: label,
              ),
              style: style.copyWith(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                side: MaterialStateProperty.resolveWith((states) {
                  return BorderSide(
                    color: states.contains(MaterialState.disabled)
                        ? theme.disabledColor
                        : theme.primaryColor,
                  );
                }),
              ),
            );
          },
        );

  ///
  SimpleButton.icon({
    required Widget icon,
    VoidCallback? onPressed,
    super.key,
  }) : _child = IconButton(
          onPressed: onPressed,
          icon: icon,
          padding: EdgeInsets.zero,
          splashRadius: 18,
          constraints: BoxConstraints.tight(
            const Size.square(32),
          ),
        );

  final Widget _child;

  @override
  Widget build(BuildContext context) => _child;
}

///
class SimpleLoader extends StatelessWidget {
  ///
  const SimpleLoader({
    required this.loading,
    required this.child,
    this.loader,
    super.key,
  });

  ///
  final bool loading;

  ///
  final Widget child;

  ///
  final Widget? loader;

  ///
  static Widget sizedLoader({
    double dimension = 20,
    Color? color,
    Widget? loader,
  }) =>
      SizedBox.square(
        dimension: dimension,
        child: RepaintBoundary(
          child: loader ??
              CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
        ),
      );

  ///
  static Widget paddedLoader({
    EdgeInsetsGeometry? padding,
    Color? color,
    Widget? loader,
  }) =>
      Padding(
        padding: padding ?? const EdgeInsets.all(3),
        child: RepaintBoundary(
          child: loader ??
              CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: loader ?? paddedLoader(),
      crossFadeState:
          loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: kThemeChangeDuration,
    );
  }
}
