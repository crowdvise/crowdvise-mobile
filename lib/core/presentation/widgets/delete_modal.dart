// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:the_lex_app/core/presentation/utils/navigation_mixin.dart';
// import 'package:the_lex_app/features/feed/presentation/widgets/widgets.dart';

// class DeleteModal extends StatelessWidget {
//   const DeleteModal({
//     super.key,
//     required this.onDelete,
//   });

//   final VoidCallback onDelete;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: MediaQuery.of(context).viewInsets,
//       child: IntrinsicHeight(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 50,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.onSurface,
//                     borderRadius: BorderRadius.circular(150),
//                   ),
//                 ),
//               ),
//               const Gap(16),
//               clickbleRow(
//                 icon: Icons.delete_outline_rounded,
//                 text: 'Delete Matter',
//                 theme: theme,
//                 onTap: () {
//                   context.pop();
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         backgroundColor: theme.colorScheme.surface,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         title: const Text('Delete Matter'),
//                         content: const Text(
//                           'Are you sure you want to delete this matter? This action is irreversable',
//                         ),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop(); // Dismiss the dialog
//                             },
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: onDelete,
//                             child: Text(
//                               'Delete',
//                               style: TextStyle(
//                                 color: theme.colorScheme.error,
//                               ), // Highlight delete action
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//               const Gap(24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
