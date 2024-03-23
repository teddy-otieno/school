// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shulesmart/models/student.dart';
import 'package:shulesmart/repository/parent_dash.dart';

class ParentInformaticsCard extends StatelessWidget {
  final ParentInformaticData informatics_data;

  const ParentInformaticsCard({super.key, required this.informatics_data});

  @override
  Widget build(BuildContext context) {
    var students_running_low = informatics_data.student_balances.fold(
      0,
      (value, element) =>
          value + (element.status == StudentAccountStatus.low ? 1 : 0),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Overall Balance",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.inverseSurface)),
          const SizedBox(height: 16),
          Text(
            informatics_data.overall_balance,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            "For ${informatics_data.learner_count} Learners...",
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 12),
          students_running_low > 0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_rounded,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 4),
                    Text("Learners Running Low $students_running_low",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error)),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
