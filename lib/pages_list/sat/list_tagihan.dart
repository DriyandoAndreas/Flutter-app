import 'package:flutter/material.dart';
import 'package:app5/pages_list/sat/list_tagihan_ta.dart';
import 'package:app5/widgets/widget_invoice.dart';

class ListTagihan extends StatelessWidget {
  const ListTagihan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const SingleChildScrollView(
          child: Column(
        children: [
          ListTagihanTa(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: WidgetInvoice(),
          ),
        ],
      )),
    );
  }
}
