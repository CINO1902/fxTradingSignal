import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/getSIgnals/presentation/widgets/timeformatter.dart';
import 'package:fx_trading_signal/features/getcopies/domain/entities/getCopyModel.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/appColors.dart';
import '../../../getSIgnals/presentation/widgets/signalwidget.dart';

class continueCopy extends StatelessWidget {
  const continueCopy({
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
        border: Border(left: BorderSide(color: AppColors.ksuccessColor300)),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
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
                          color: copydata.relatedData!.accessType == 'Pro'
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                  Gap(10),
                  Text('Copied ${timeAgo(copydata.dateCreated!)}')
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 24,
                width: 65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.ksuccessColor100.withOpacity(.2)),
                child: Center(
                  child: Text(
                    'Running',
                    style: TextStyle(
                        color: AppColors.ksuccessColor300, fontSize: 10),
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
            ],
          ),
          Gap(10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 32,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 32,
                  width: 70,
                  color: Color(0xffF6F6F6),
                  child: Center(
                    child: Text(
                      'SL: ${copydata.relatedData!.stopLoss}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Gap(20),
                DynamicTextRow(
                  text: copydata.relatedData!.takeProfit!,
                  entries: copydata.relatedData!.entries!,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
