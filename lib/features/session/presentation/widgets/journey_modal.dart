import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JourneyModal extends StatefulWidget {
  const JourneyModal({super.key, this.isEditMode = false});
  final bool isEditMode;

  @override
  State<JourneyModal> createState() => _JourneyModalState();
}

class _JourneyModalState extends State<JourneyModal> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF09090C),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF33333A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Gap(16),
            Text(
              widget.isEditMode ? 'Edit Stage' : 'Add a new stage',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Gap(24),
            Text(
              "STAGE TITLE",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white54,
                letterSpacing: 1.5,
              ),
            ),
            const Gap(8),
            InputField(
              hint: 'Give your stage a short title',
              maxLines: 3,
              onChange: (val) {},
            ),
            const Gap(24),
            Text(
              "STAGE DESCRIPTION",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white54,
                letterSpacing: 1.5,
              ),
            ),
            const Gap(8),
            InputField(
              hint: 'Add context for the expert',
              maxLength: 250,
              maxLines: 3,
              onChange: (val) {},
            ),
            const Gap(32),
            Button(
              title: widget.isEditMode ? 'Update Stage' : 'Add Stage',
              onPressed: () {
                context.pop();
              },
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}

class DeleteModal extends StatefulWidget {
  const DeleteModal({super.key});

  @override
  State<DeleteModal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<DeleteModal> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF09090C),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF33333A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Gap(24),
            Center(
              child: Icon(Icons.info_outline, size: 40, color: electricBlue),
            ),
            const Gap(16),
            Text(
              'Are you sure?',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Gap(24),
            Text(
              "This will permenently delete your stage and all the information associated with it.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white54,
                letterSpacing: 1.5,
              ),
            ),

            const Gap(32),
            Row(
              children: [
                Expanded(
                  child: BorderButton(
                    title: 'Cancel',
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Button(
                    title: 'Delete',

                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
