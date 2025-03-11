import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:gap/gap.dart';

import '../../../getSIgnals/presentation/widgets/timeformatter.dart';
import '../../../getTraders/domain/usecases/pnlCalculator.dart';
import '../../domain/entities/getCopyModel.dart';

class CompletedCopy extends StatelessWidget {
  const CompletedCopy({
    super.key,
    required this.copydata,
    required this.refo,
  });
  final CopyTrade copydata;
  final WidgetRef refo;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.kprimaryColor300)),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      // height: 181,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 33,
                    width: 40,
                    color: copydata.relatedData!.accessType == 'Pro'
                        ? AppColors.kprimaryColor300
                        : AppColors.kwarningColor50,
                    child: Center(
                        child: Text(
                      copydata.relatedData!.accessType!,
                      style: TextStyle(
                          color: copydata.relatedData!.accessType! == 'Pro'
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                  Gap(10),
                  Text(
                      'Completed ${timeAgo(copydata.relatedData!.dateCompleted!)}')
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 24,
                width: 65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.kprimaryColor100.withOpacity(.2)),
                child: Center(
                  child: Text(
                    'Completed',
                    style: TextStyle(
                        color: AppColors.kprimaryColor300, fontSize: 10),
                  ),
                ),
              )
            ],
          ),
          Gap(20),
          Text(
            '${copydata.relatedData!.signalName!} ${copydata.relatedData!.order! == 'Buy' ? 'Long' : 'Short'} Position',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'ENTRY',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(' ${copydata.relatedData!.entry}'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Result (Standard Lot)',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                      calculatePNL(
                        tradeType: copydata.relatedData!.order!.toUpperCase(),
                        currencyPair: copydata.relatedData!.signalName!,
                        entryPrice: double.parse(
                          copydata.relatedData!.entry!,
                        ),
                        currentPrice: double.parse(
                          copydata.relatedData!.finalprice!,
                        ),
                      ).toString(),
                      style: TextStyle(
                          color: calculatePNL(
                            tradeType:
                                copydata.relatedData!.order!.toUpperCase(),
                            currencyPair: copydata.relatedData!.signalName!,
                            entryPrice: double.parse(
                              copydata.relatedData!.entry!,
                            ),
                            currentPrice: double.parse(
                              copydata.relatedData!.finalprice!,
                            ),
                          ).toString().contains('-')
                              ? AppColors.kErrorColor300
                              : AppColors.ksuccessColor300,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
