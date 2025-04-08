import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/Pricing/presentation/provider/planProvider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../constant/snackBar.dart';

class PurchaseHelper {
  final BuildContext context;
  final String userId;
  final String serviceName;

  PurchaseHelper({
    required this.context,
    required this.userId,
    required this.serviceName,
  });

  /// Fetch offerings and make a purchase.
  Future<bool> fetchAndPurchase(
      String offeringId, int planId, int packageIndex, WidgetRef ref) async {
    bool purchase = false;
    try {
      print('Plan Id for the plan $planId');

      // Apply timeout only when fetching offerings.
      const offeringsTimeout = Duration(seconds: 65);
      final offerings = await Purchases.getOfferings().timeout(offeringsTimeout,
          onTimeout: () {
        throw TimeoutException(
            'Fetching offerings timed out after $offeringsTimeout');
      });

      print(offerings);
      // Get the desired package from the specified offering.
      final Package? package =
          offerings.getOffering(offeringId)?.availablePackages[packageIndex];
      print(package);
      if (package == null) {
        print('No package available for offering: $offeringId');
        return false;
      }

      String randomString = generateRandomAlphanumeric(12);

      // Make the purchase. No timeout is applied here.
      bool purchaseSuccessful = await makePurchase(
          package, userId, randomString, offeringId, planId, ref);
      purchase = purchaseSuccessful;
      if (purchaseSuccessful) {
        // Call backend function.
        await ref.read(planProvider).buyPlan(ref, planId);
      }
    } on TimeoutException catch (e) {
      SnackBarService.notifyAction(
        context,
        status: SnackbarStatus.fail,
        message: "Network connection timeout",
      );
      print('Operation timed out: ${e.message}');
    } on PlatformException catch (e) {
      SnackBarService.notifyAction(
        context,
        status: SnackbarStatus.fail,
        message: "Something went wrong",
      );
      print('Error fetching offerings: ${e.message}');
    }
    return purchase;
  }

  String generateRandomAlphanumeric(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

  /// Make a purchase using the provided package.
  Future<bool> makePurchase(
    Package package,
    String userId,
    String
        token, // Assuming the token is for authentication and not part of the RevenueCat identity.
    String offeringId,
    int planId,
    WidgetRef ref,
  ) async {
    try {
      // Use a stable RevenueCat user identifier.
      // If merging multiple identifiers is needed, consider using createAlias.
      await Purchases.logIn(userId);

      // Attempt to make the purchase.
      // For a consumable product, ensure that the product is set as consumable on the store.
      final CustomerInfo customerInfo =
          await Purchases.purchasePackage(package);

      // (Restoring purchases is commented out because for consumables it may not be required.)
      // await Purchases.restorePurchases();

      // Extract the purchase token (e.g., for server-side validation).
      final String? purchaseToken =
          customerInfo.entitlements.active.values.lastOrNull?.identifier;

      if (purchaseToken != null) {
        print('Purchase Token: $purchaseToken');
      }

      print('Purchase successful for user: $userId');
      return true;
    } on PlatformException catch (e) {
      // Handle specific RevenueCat errors.
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        print('Purchase cancelled by the user.');
        SnackBarService.showSnackBar(
          context,
          title: "Error",
          status: SnackbarStatus.fail,
          body: 'Purchase cancelled by the user.',
        );
      } else {
        print('Error making purchase: ${e.message}');
        SnackBarService.showSnackBar(
          context,
          title: "Error",
          status: SnackbarStatus.fail,
          body: 'Error making purchase:',
        );
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      SnackBarService.showSnackBar(
        context,
        title: "Error",
        status: SnackbarStatus.fail,
        body: 'Unexpected error',
      );
      return false;
    }
  }
}
