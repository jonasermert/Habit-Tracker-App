import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/theme/app_theme.dart';

void main() {
  test('Helles und dunkles Theme haben lesbare Kontrastfarben', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(light.colorScheme.surface, AppTheme.surfaceLight);
    expect(dark.colorScheme.surface, AppTheme.surfaceDark);
    expect(light.colorScheme.onSurface, AppTheme.foregroundLight);
    expect(dark.colorScheme.onSurface, AppTheme.foregroundDark);
  });
}
