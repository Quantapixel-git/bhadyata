
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder if you want different web/mobile behavior
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.primary,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _onBack,
        ),
        title: TextField(
          // readOnly: true,
          // onTap: () {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(builder: (_) => const SearchScreen()),
          //   );
          // },
          decoration: InputDecoration(
            hintText: "Search jobs...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.search, size: 72, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Start typing to search jobs or services',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
