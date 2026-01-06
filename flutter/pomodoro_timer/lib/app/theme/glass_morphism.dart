import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Glass morphism effect widgets for iOS/macOS liquid glass display theme.
/// 
/// Provides reusable widgets that implement Apple's vibrancy and
/// translucency design principles with blur effects.

/// Check if running on Apple platform
bool get _isApplePlatform {
  if (kIsWeb) return false;
  return Platform.isIOS || Platform.isMacOS;
}

/// A card with glass morphism effect.
/// 
/// Creates a frosted glass appearance with blur and subtle borders.
/// Only applies effect on iOS/macOS platforms.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double blurAmount;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.padding,
    this.margin,
    this.color,
    this.blurAmount = 10.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply glass effect on Apple platforms
    if (!_isApplePlatform) {
      return Card(
        margin: margin,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      );
    }

    final theme = Theme.of(context);
    final defaultColor = color ?? 
      theme.colorScheme.surface.withValues(alpha: 
        theme.brightness == Brightness.dark ? 0.5 : 0.7
      );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(
          color: Colors.white.withValues(alpha: 
            theme.brightness == Brightness.dark ? 0.1 : 0.2
          ),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: defaultColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A container with glass morphism effect.
/// 
/// Creates a frosted glass appearance with blur effect.
/// Only applies effect on iOS/macOS platforms.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double blurAmount;
  final Border? border;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.color,
    this.blurAmount = 10.0,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply glass effect on Apple platforms
    if (!_isApplePlatform) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      );
    }

    final theme = Theme.of(context);
    final defaultColor = color ?? 
      theme.colorScheme.surface.withValues(alpha: 
        theme.brightness == Brightness.dark ? 0.5 : 0.7
      );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(
          color: Colors.white.withValues(alpha: 
            theme.brightness == Brightness.dark ? 0.1 : 0.2
          ),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: defaultColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// An app bar with glass morphism effect.
/// 
/// Creates a translucent app bar with blur effect.
/// Only applies effect on iOS/macOS platforms.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double blurAmount;
  final Color? backgroundColor;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.blurAmount = 10.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply glass effect on Apple platforms
    if (!_isApplePlatform) {
      return AppBar(
        title: title,
        actions: actions,
        leading: leading,
        centerTitle: centerTitle,
      );
    }

    final theme = Theme.of(context);
    final defaultColor = backgroundColor ?? 
      theme.colorScheme.surface.withValues(alpha: 0.8);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: AppBar(
          title: title,
          actions: actions,
          leading: leading,
          centerTitle: centerTitle,
          backgroundColor: defaultColor,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A bottom navigation bar with glass morphism effect.
/// 
/// Creates a translucent navigation bar with blur effect.
/// Only applies effect on iOS/macOS platforms.
class GlassNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<NavigationDestination> destinations;
  final double blurAmount;
  final Color? backgroundColor;

  const GlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    this.onDestinationSelected,
    this.blurAmount = 10.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply glass effect on Apple platforms
    if (!_isApplePlatform) {
      return NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      );
    }

    final theme = Theme.of(context);
    final defaultColor = backgroundColor ?? 
      theme.colorScheme.surface.withValues(alpha: 0.8);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
          backgroundColor: defaultColor,
          elevation: 0,
        ),
      ),
    );
  }
}

/// A dialog with glass morphism effect.
/// 
/// Creates a translucent dialog with blur effect.
/// Only applies effect on iOS/macOS platforms.
class GlassDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final double borderRadius;
  final double blurAmount;
  final Color? backgroundColor;

  const GlassDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.borderRadius = 24.0,
    this.blurAmount = 20.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply glass effect on Apple platforms
    if (!_isApplePlatform) {
      return AlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    }

    final theme = Theme.of(context);
    final defaultColor = backgroundColor ?? 
      theme.colorScheme.surface.withValues(alpha: 0.95);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: defaultColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 
                  theme.brightness == Brightness.dark ? 0.1 : 0.2
                ),
                width: 1,
              ),
            ),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: title,
              content: content,
              actions: actions,
            ),
          ),
        ),
      ),
    );
  }
}

/// A bottom sheet with glass morphism effect.
/// 
/// Creates a translucent bottom sheet with blur effect.
/// Only applies effect on iOS/macOS platforms.
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurAmount;
  final Color? backgroundColor;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blurAmount = 20.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply glass effect on Apple platforms
    if (!_isApplePlatform) {
      return child;
    }

    final theme = Theme.of(context);
    final defaultColor = backgroundColor ?? 
      theme.colorScheme.surface.withValues(alpha: 0.95);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 
                  theme.brightness == Brightness.dark ? 0.1 : 0.2
                ),
                width: 1,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}