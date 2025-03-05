import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/colors.dart';

import '../generated/l10n.dart';

class OrderProgress extends StatelessWidget {
  const OrderProgress({super.key, required this.activeStep});

  final int activeStep;
  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: activeStep,
      stepShape: StepShape.rRectangle,
      stepBorderRadius: 15,
      borderThickness: 2,
      stepRadius: 28,
      finishedStepBorderColor: AppColors().green(),
      finishedStepTextColor: AppColors().green(),
      finishedStepBackgroundColor: AppColors().green(),
      activeStepIconColor: AppColors().green(),
      showLoadingAnimation: false,
      steps: [
        EasyStep(
          customStep: Icon(Icons.shopping_cart, color: activeStep >= 1 ? AppColors().white() : AppColors().black(),),
          customTitle:  Text(
            S.of(context).panier,
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: Icon(Icons.check, color: activeStep >= 2 ? AppColors().white() : AppColors().black(),),
          customTitle:  Text(
            S.of(context).vrification,
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: Icon(Icons.payment, color: activeStep == 3 ? AppColors().white() : AppColors().black(),),
          customTitle:  Text(
            S.of(context).paiement,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
