import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

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
      finishedStepBorderColor: Color(0xFF2AB24A),
      finishedStepTextColor: Color(0xFF2AB24A),
      finishedStepBackgroundColor: Color(0xFF2AB24A),
      activeStepIconColor: Color(0xFF2AB24A),
      showLoadingAnimation: false,
      steps: [
        EasyStep(
          customStep: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Opacity(
              opacity: 1,
              child: Icon(Icons.shopping_cart),
            ),
          ),
          customTitle: const Text(
            'Panier',
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Opacity(
              opacity: 1,
              child: Icon(Icons.check),
            ),
          ),
          customTitle: const Text(
            'Vérification',
            textAlign: TextAlign.center,
          ),
        ),
        EasyStep(
          customStep: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Opacity(
              opacity: 1,
              child: Icon(Icons.payment),
            ),
          ),
          customTitle: const Text(
            'Paiement',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
