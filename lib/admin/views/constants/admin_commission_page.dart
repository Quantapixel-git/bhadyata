import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/admin/views/sidebar_dashboard/admin_sidebar.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AdminCommissionPage extends StatefulWidget {
  const AdminCommissionPage({super.key});

  @override
  State<AdminCommissionPage> createState() => _AdminCommissionPageState();
}

class _AdminCommissionPageState extends State<AdminCommissionPage> {
  bool isLoading = true;
  double commission = 0.0;
  final TextEditingController _controller = TextEditingController();
  bool updating = false;

  static const String _getUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/getCommission';
  static const String _postUrl =
      'https://dialfirst.in/quantapixel/badhyata/api/updateCommission';

  @override
  void initState() {
    super.initState();
    debugPrint('[AdminCommissionPage] initState -> fetching commission');
    _fetchCommission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchCommission() async {
    setState(() => isLoading = true);
    debugPrint('[fetchCommission] GET $_getUrl');
    try {
      final res = await http.get(Uri.parse(_getUrl));
      debugPrint(
        '[fetchCommission] response status=${res.statusCode} body=${res.body}',
      );
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        final val =
            (j['data'] != null && j['data']['commission_percent'] != null)
            ? (j['data']['commission_percent'] as num).toDouble()
            : 0.0;
        setState(() {
          commission = val;
          _controller.text = commission.toStringAsFixed(2);
          isLoading = false;
        });
        debugPrint('[fetchCommission] parsed commission=$commission');
      } else {
        setState(() => isLoading = false);
        debugPrint('[fetchCommission] non-200 status: ${res.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            content: Text('Server error: ${res.statusCode}'),
          ),
        );
      }
    } catch (e, st) {
      setState(() => isLoading = false);
      debugPrint('_fetchCommission error: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Error fetching commission: $e'),
        ),
      );
    }
  }

  Future<void> _updateCommission() async {
    final raw = _controller.text.trim();
    debugPrint('[updateCommission] input raw="$raw"');
    if (raw.isEmpty) {
      debugPrint('[updateCommission] input empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Enter commission percent'),
        ),
      );
      return;
    }

    double? val = double.tryParse(raw);
    debugPrint('[updateCommission] parsed val=$val');
    if (val == null || val < 0) {
      debugPrint('[updateCommission] invalid number');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Enter a valid non-negative number'),
        ),
      );
      return;
    }

    // Optional: enforce max 100
    if (val > 100) {
      debugPrint('[updateCommission] value > 100, asking confirmation');
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Large value'),
          content: const Text('Commission > 100% — are you sure?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Proceed'),
            ),
          ],
        ),
      );
      if (ok != true) {
        debugPrint('[updateCommission] user cancelled >100 confirmation');
        return;
      }
    }

    setState(() => updating = true);
    debugPrint(
      '[updateCommission] POST $_postUrl body=${{'commission_percent': val}}',
    );
    try {
      final body = jsonEncode({'commission_percent': val});
      final res = await http.post(
        Uri.parse(_postUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      debugPrint(
        '[updateCommission] response status=${res.statusCode} body=${res.body}',
      );
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        if (j['status'] == 1) {
          final newVal =
              (j['data'] != null && j['data']['commission_percent'] != null)
              ? (j['data']['commission_percent'] as num).toDouble()
              : val;
          setState(() {
            commission = newVal;
            _controller.text = commission.toStringAsFixed(2);
            updating = false;
          });
          debugPrint('[updateCommission] updated commission=$commission');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              content: Text('Commission updated successfully'),
            ),
          );
        } else {
          setState(() => updating = false);
          debugPrint(
            '[updateCommission] api returned error message=${j['message'] ?? 'none'}',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              content: Text('Update failed: ${j['message'] ?? 'Unknown'}'),
            ),
          );
        }
      } else {
        setState(() => updating = false);
        debugPrint('[updateCommission] non-200 status ${res.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            content: Text('Server error: ${res.statusCode}'),
          ),
        );
      }
    } catch (e, st) {
      setState(() => updating = false);
      debugPrint('_updateCommission error: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: Text('Error updating commission: $e'),
        ),
      );
    }
  }

  Widget _body() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current commission (%)',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                commission.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text('%', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Update commission',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'e.g. 12.50',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: updating ? null : _updateCommission,
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
                label: Text(
                  updating ? 'Saving...' : 'Save',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Notes', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text('• Value is stored as percent (0 - 100).'),
          const Text('• Use decimal values for precision, e.g. 12.50.'),
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
              'Commission Percent',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: _fetchCommission,
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
