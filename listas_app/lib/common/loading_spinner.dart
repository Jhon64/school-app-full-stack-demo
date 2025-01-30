import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

void onLoadingSpinner(bool? loading, BuildContext context) {
  if (loading == null || loading == false) {
    context.loaderOverlay.hide();
  } else {
    context.loaderOverlay.show();
  }
}
