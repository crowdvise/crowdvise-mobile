// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:the_lex_app/core/presentation/utils/navigation_mixin.dart';
// import 'package:the_lex_app/core/presentation/widgets/button.dart';
// import 'package:the_lex_app/core/presentation/widgets/pop_widget.dart';
// import 'package:the_lex_app/core/presentation/widgets/provider_widget.dart';
// import 'package:the_lex_app/features/wallet/presentation/manager/wallet_provider.dart';

// typedef AmountCallback = void Function(String);

// class LexNumPad extends StatefulWidget {
//   const LexNumPad({
//     super.key,
//     required this.callback,
//     required this.title,
//   });
//   final AmountCallback callback;
//   final String title;

//   @override
//   State<LexNumPad> createState() => _LexNumPadState();
// }

// class _LexNumPadState extends State<LexNumPad> {
//   String _amount = '';
//   String currency = "\u20a6";
//   String _amountFieldValue = '0.0';
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ProviderWidget(
//         padding: 8,
//         provider: WalletProvider(),
//         children: (provider, theme) {
//           return [
//             const Gap(20),
//             Row(
//               children: [
//                 PopWidget(
//                   callback: () {
//                     context.pop();
//                   },
//                 ),
//                 const Gap(12),
//                 Text(
//                   widget.title,
//                   style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
//                 ),
//               ],
//             ),
//             Expanded(child: Container()),
//             Column(
//               children: [
//                 RichText(
//                   text: TextSpan(
//                       text: '$currency ',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: theme.colorScheme.onSurface,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: _amountFieldValue,
//                           style: theme.textTheme.titleLarge!
//                               .copyWith(fontSize: 48),
//                         )
//                       ]),
//                   textAlign: TextAlign.end,
//                   textHeightBehavior: const TextHeightBehavior(
//                       applyHeightToFirstAscent: true,
//                       applyHeightToLastDescent: false,
//                       leadingDistribution: TextLeadingDistribution.even),
//                 ),
//                 const Gap(50),
//                 _numberRow('1', '2', '3'),
//                 _numberRow('4', '5', '6'),
//                 _numberRow('7', '8', '9'),
//                 const Gap(2),
//                 _bottomRow(),
//                 const Gap(26),
//                 Button(
//                   title: 'Continue To Pay',
//                   onPressed: () {
//                     widget.callback(_amountFieldValue);
//                   },
//                   isLoading: false,
//                 ),
//                 const Gap(42)
//               ],
//             )
//           ];
//         });
//   }

//   Widget _numberRow(first, second, last) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [_number(first), _number(second), _number(last)],
//     );
//   }

//   Widget _bottomRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [_number('.'), _number('0'), _delete()],
//     );
//   }

//   Widget _delete() {
//     final size = MediaQuery.of(context).size.width - 48;
//     return InkWell(
//       splashColor: ThemeData().colorScheme.tertiary,
//       hoverColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//       onTap: _amount.isEmpty
//           ? null
//           : () {
//               if (_amount.isNotEmpty) {
//                 _amount = _amount.substring(0, _amount.length - 1);
//                 if (_amount.isNotEmpty) {
//                   if (_amount[_amount.length - 1] == '.') {
//                     _amount = _amount.substring(0, _amount.length - 1);
//                   }
//                 }
//                 setState(() {
//                   _amountFieldValue =
//                       formatMoney(double.tryParse(_amount) ?? 0);
//                 });
//               }
//             },
//       child: SizedBox(
//         width: size * 0.33,
//         height: 80,
//         child: const Center(
//           child: Icon(Icons.backspace_outlined),
//         ),
//       ),
//     );
//   }

//   Widget _number(value) {
//     final size = MediaQuery.of(context).size.width - 48;
//     return InkWell(
//       splashColor: ThemeData().colorScheme.tertiary,
//       hoverColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//       onTap: _amount.length >= 10
//           ? null
//           : () {
//               if (value == '.' && _amount.contains('.')) {
//                 return;
//               }
//               if (_amount.contains('.')) {
//                 final isDecimalSet = _amount.trim().split('.').last.length > 1;
//                 if (isDecimalSet) {
//                   return;
//                 }
//               }

//               if (value == 0 && _amount.isEmpty) {
//                 return;
//               }
//               _amount = '$_amount$value';
//               setState(() {
//                 _amountFieldValue = formatMoney(double.tryParse(_amount) ?? 0);
//               });
//             },
//       child: Container(
//         width: size * 0.33,
//         height: 80,
//         margin: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//             border: Border.all(color: ThemeData().colorScheme.onSurface),
//             borderRadius: BorderRadius.circular(10)),
//         child: Center(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 25,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// String formatMoney(data) {
//   final oCcy = NumberFormat("#,##0.0", "en_US");
//   return oCcy.format(data);
// }
