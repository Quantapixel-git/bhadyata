// admin_wallet_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AdminWalletPage extends StatefulWidget {
  const AdminWalletPage({super.key});

  @override
  State<AdminWalletPage> createState() => _AdminWalletPageState();
}

class _AdminWalletPageState extends State<AdminWalletPage> {
  bool isLoading = true;
  int walletFrom = 0;
  int walletTo = 0;

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  bool updating = false;

  static const String _getUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/getWalletReferral';
  static const String _postUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/updateWalletReferral';

  @override
  void initState() {
    super.initState();
    _fetchWalletReferral();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _fetchWalletReferral() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse(_getUrl));
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        final data = j['data'] ?? {};
        final fromVal = (data['wallet_referred_from'] ?? 0);
        final toVal = (data['wallet_referred_to'] ?? 0);

        setState(() {
          walletFrom = (fromVal is num)
              ? fromVal.toInt()
              : int.tryParse(fromVal.toString()) ?? 0;
          walletTo = (toVal is num)
              ? toVal.toInt()
              : int.tryParse(toVal.toString()) ?? 0;
          _fromController.text = walletFrom.toString();
          _toController.text = walletTo.toString();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            content: Text('Server error: ${res.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Error fetching wallet referral: $e'),
        ),
      );
    }
  }

  Future<void> _updateWalletReferral() async {
    final rawFrom = _fromController.text.trim();
    final rawTo = _toController.text.trim();

    if (rawFrom.isEmpty || rawTo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Please fill both values'),
        ),
      );
      return;
    }

    final int? fromVal = int.tryParse(rawFrom);
    final int? toVal = int.tryParse(rawTo);

    if (fromVal == null || toVal == null || fromVal < 0 || toVal < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Enter valid non-negative integers'),
        ),
      );
      return;
    }

    // OPTIONAL: You might want to enforce from >= to or some business rule.
    // If you want that, uncomment and adapt:
    // if (fromVal < toVal) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('wallet_referred_from should be >= wallet_referred_to')),
    //   );
    //   return;
    // }

    setState(() => updating = true);

    try {
      final body = jsonEncode({
        'wallet_referred_from': fromVal,
        'wallet_referred_to': toVal,
      });

      final res = await http.post(
        Uri.parse(_postUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        if (j['status'] == 1) {
          final data = j['data'] ?? {};
          final newFrom = (data['wallet_referred_from'] ?? fromVal);
          final newTo = (data['wallet_referred_to'] ?? toVal);

          setState(() {
            walletFrom = (newFrom is num)
                ? newFrom.toInt()
                : int.tryParse(newFrom.toString()) ?? fromVal;
            walletTo = (newTo is num)
                ? newTo.toInt()
                : int.tryParse(newTo.toString()) ?? toVal;
            _fromController.text = walletFrom.toString();
            _toController.text = walletTo.toString();
            updating = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              content: Text('Wallet referral values updated successfully'),
            ),
          );
        } else {
          setState(() => updating = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update failed: ${j['message'] ?? 'Unknown'}'),
            ),
          );
        }
      } else {
        setState(() => updating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${res.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => updating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating wallet referral: $e')),
      );
    }
  }

  Widget _body() {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wallet referral System',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              // current display
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current values',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Referred By: $walletFrom',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Referred To:   $walletTo',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Update wallet referral',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _fromController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'wallet_referred_from',
                    labelText: 'Referred By',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _toController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'wallet_referred_to',
                    labelText: 'Referred To',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: updating ? null : _updateWalletReferral,
                icon: updating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(updating ? 'Saving...' : 'Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Text('Notes', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text('• Values are integers (wallet amount units).'),
          // const Text('• Use Postman to test the GET and POST endpoints shown above.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminDashboardWrapper(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Wallet Referral Constants',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: _fetchWalletReferral,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              width: double.infinity,
              child: _body(),
            ),
          ),
        ],
      ),
    );
  }
}
