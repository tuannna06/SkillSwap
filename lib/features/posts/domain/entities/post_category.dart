import 'package:flutter/material.dart';

enum PostCategory {
  programming,
  design,
  academic,
  manualLabor,
  sports,
  other,
}

extension PostCategoryExtension on PostCategory {

  String get label {
    switch (this) {
      case PostCategory.programming:
        return 'Programming';
      case PostCategory.design:
        return 'Design';
      case PostCategory.academic:
        return 'Academic';
      case PostCategory.manualLabor:
        return 'Manual Labor';
      case PostCategory.sports:
        return 'Sports';
      case PostCategory.other:
        return 'Other';
    }
  }

  Color get color {
    switch (this) {
      case PostCategory.programming:
        return Colors.blueAccent;
      case PostCategory.design:
        return Colors.purpleAccent;
      case PostCategory.academic:
        return Colors.greenAccent;
      case PostCategory.manualLabor:
        return Colors.orangeAccent;
      case PostCategory.sports:
        return Colors.redAccent;
      case PostCategory.other:
        return Colors.grey;
    }
  }
}
