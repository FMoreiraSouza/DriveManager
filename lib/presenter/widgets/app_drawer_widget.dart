// import 'package:flutter/material.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           SafeArea(
//             bottom: false,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               height: 100,
//               decoration: const BoxDecoration(color: Colors.black),
//               child: Row(
//                 children: <Widget>[
//                   const SizedBox(width: 8.0),
//                   Image.asset(
//                     'assets/images/drive_manager_logo.png',
//                     width: 80,
//                     fit: BoxFit.contain,
//                     color: Colors.white,
//                   ),
//                   const Expanded(
//                     child: Text(
//                       'Bem vindo',
//                       textAlign: TextAlign.center,
//                       maxLines: 3,
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   Visibility(
//                     visible: !isSelectStorePage,
//                     child: ListTile(
//                       leading: const Icon(Icons.store),
//                       title: Text('${intl?.alterar_loja}'),
//                       onTap: controller.selectStore,
//                     ),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.person),
//                     title: Text('${intl?.minha_conta}'),
//                     onTap: () => controller.profile(isSelectStorePage),
//                   ),
//                   Visibility(
//                     visible: controller.loggedUser,
//                     child: ListTile(
//                       leading: const Icon(Icons.credit_card),
//                       title: Text('${intl?.meios_de_pagamento}'),
//                       onTap: () => controller.cardList(isSelectStorePage),
//                     ),
//                   ),
//                   Visibility(
//                     visible: !isSelectStorePage,
//                     child: ListTile(
//                       leading: const Icon(Icons.store),
//                       title: Text('${intl?.catalogo}'),
//                       onTap: () => controller.store(),
//                     ),
//                   ),
//                   Visibility(
//                     visible: !isSelectStorePage,
//                     child: ListTile(
//                       leading: const Icon(Icons.mail_outline),
//                       title: Text('${intl?.contato}'),
//                       onTap: () => controller.contact(isSelectStorePage),
//                     ),
//                   ),
//                   Visibility(
//                     visible: !isSelectStorePage,
//                     child: ListTile(
//                       leading: const Icon(Icons.percent),
//                       title: Text('${intl?.cupons}'),
//                       onTap: () => controller.coupons(isSelectStorePage),
//                     ),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.settings),
//                     title: Text('${intl?.configuracoes}'),
//                     onTap: () => controller.settings(isSelectStorePage),
//                   ),
//                   Visibility(
//                     visible: !Session.instance.isSameCompany(
//                             globalDataController.selectedStore?.owner?.company?.id ?? -1) &&
//                         Session.instance.hasSession() &&
//                         !isSelectStorePage,
//                     child: Text(
//                       '(${intl?.cliente_de_outra_empresa}, ${Session.instance.companyName})',
//                       textAlign: TextAlign.center,
//                       maxLines: 3,
//                       style: const TextStyle(color: Colors.black, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
