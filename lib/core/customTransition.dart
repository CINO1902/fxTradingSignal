import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

Page<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  if (Platform.isIOS) {
    // Return a CupertinoPage for iOS to preserve the swipe-back gesture
    return CupertinoPage<T>(
      key: state.pageKey,
      child: child,
    );
  } else {
    // Apply custom transition for other platforms
    return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: const AlwaysStoppedAnimation(1), // Adjust opacity as desired
        child: child,
      );
      //           SlideTransition(
      //   position: animation.drive(tween),
      //   child: child,
      // );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
  }
}



// CustomTransitionPage buildPageWithDefaultTransition<T>({
//   required BuildContext context,
//   required GoRouterState state,
//   required Widget child,
// }) {
//   return CustomTransitionPage<T>(
//     key: state.pageKey,
//     child: child,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1.0, 0);
//       const end = Offset.zero;
//       const curve = Curves.easeInOut;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return FadeTransition(
//         opacity: const AlwaysStoppedAnimation(1), // Adjust opacity as desired
//         child: child,
//       );
//       //           SlideTransition(
//       //   position: animation.drive(tween),
//       //   child: child,
//       // );
//     },
//     transitionDuration: const Duration(milliseconds: 200),
//   );
// }