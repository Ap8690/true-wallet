import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/models/transaction_history.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionHistory> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList('transactions') ?? [];
    setState(() {
      transactions = transactionsJson
          .map((json) => TransactionHistory.fromJson(jsonDecode(json)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomHomeAppbar(
          showBackWidget: true,
          centreText: 'Transaction History',
          onBackTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: transactions.isEmpty
          ? Center(
              child: CustomText(
                text: 'No transactions yet',
                style: CustomTextStyles.textTitle(),
              ),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _buildTransactionCard(tx);
              },
            ),
    );
  }

  Widget _buildTransactionCard(TransactionHistory tx) {
    return GestureDetector(
      onTap: () async {
        if (tx.explorerUrl.isNotEmpty) {
          final url = '${tx.explorerUrl}/tx/${tx.hash}';
          if (await canLaunch(url)) {
            await launch(url);
          }
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: '${tx.amount} ${tx.tokenSymbol}',
                    style: CustomTextStyles.textCommon(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomText(
                    text: tx.status,
                    style: CustomTextStyles.textCommon(
                      color: CustomColor.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'From: ${Helpers.formatLongString(tx.from)}',
                style: CustomTextStyles.textLabel(color: CustomColor.grey),
              ),
              CustomText(
                text: 'To: ${Helpers.formatLongString(tx.to)}',
                style: CustomTextStyles.textLabel(color: CustomColor.grey),
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Hash: ${Helpers.formatLongString(tx.hash)}',
                style: CustomTextStyles.textLabel(color: CustomColor.blue),
              ),
              CustomText(
                text: 'Date: ${tx.timestamp.toString().split('.')[0]}',
                style: CustomTextStyles.textLabel(color: CustomColor.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
