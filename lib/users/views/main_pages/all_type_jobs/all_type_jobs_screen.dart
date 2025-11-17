import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';

class AllJobsPage extends StatefulWidget {
  const AllJobsPage({super.key});

  @override
  State<AllJobsPage> createState() => _AllJobsPageState();
}

class _AllJobsPageState extends State<AllJobsPage> {
  final List<String> carouselImages = [
    'assets/six.jpg',
    'assets/two.jpg',
    'assets/five.jpg',
  ];

  final List<Map<String, String>> salaryJobsDemo = [
    {
      'title': 'Junior Flutter Developer',
      'company': 'Innova Tech',
      'location': 'Gurgaon, HR',
      'salary': '₹25,000 - ₹35,000 / month',
      'logo': 'assets/one.png',
    },
    {
      'title': 'Sales Executive',
      'company': 'Apex Solutions',
      'location': 'Bengaluru, KA',
      'salary': '₹18,000 - ₹22,000 / month',
      'logo': 'assets/one.png',
    },
    {
      'title': 'Accountant (Entry)',
      'company': 'Mint Books',
      'location': 'Chennai, TN',
      'salary': '₹20,000 - ₹28,000 / month',
      'logo': 'assets/one.png',
    },
  ];

  int _carouselIndex = 0;
  String _query = '';
  String _selectedFilter = 'All';

  List<String> _filters = ['All', 'Remote', 'Full-time', 'Part-time'];

  List<Map<String, String>> get _filteredJobs {
    var list = salaryJobsDemo.where((job) {
      final matchesQuery =
          _query.isEmpty ||
          job['title']!.toLowerCase().contains(_query.toLowerCase()) ||
          job['company']!.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter =
          _selectedFilter == 'All' ||
          (_selectedFilter == 'Remote' &&
              job['location']!.toLowerCase().contains('remote'));
      return matchesQuery && matchesFilter;
    }).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWeb = width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: isWeb ? null : const AppDrawer(),
      appBar: isWeb
          ? null
          : AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'All Jobs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Card-style carousel with rounded corners and shadow
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 56 : 12,
                      vertical: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: isWeb ? 200 : 220,
                        color: Colors.black12,
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              itemCount: carouselImages.length,
                              itemBuilder: (context, index, realIdx) {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      carouselImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.45),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              options: CarouselOptions(
                                viewportFraction: isWeb ? 1.0 : 1.0,
                                height: isWeb ? 360 : 220,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) =>
                                    setState(() => _carouselIndex = index),
                              ),
                            ),

                            // overlay headline centered (subtle)
                            Positioned(
                              left: isWeb ? 56 : 16,
                              bottom: isWeb ? 36 : 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Monthly Salary Openings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isWeb ? 26 : 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Fresh roles from trusted employers — demo data.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: isWeb ? 14 : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // small pill indicator top-right
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    // const Icon(
                                    //   Icons.work_outline,
                                    //   color: Colors.white,
                                    //   size: 16,
                                    // ),
                                    // const SizedBox(width: 8),
                                    Text(
                                      '${_carouselIndex + 1}/${carouselImages.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Jobs list (vertical, richer card)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 56 : 12),
                    child: Column(
                      children: _filteredJobs.map((job) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _RichJobCard(
                            title: job['title']!,
                            company: job['company']!,
                            location: job['location']!,
                            salary: job['salary']!,
                            logoAsset: job['logo']!,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RichJobCard extends StatelessWidget {
  final String title, company, location, salary, logoAsset;

  const _RichJobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // company logo / avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                logoAsset,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 10,
                      //     vertical: 6,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.green.shade50,
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: const Text(
                      //     'Hiring',
                      //     style: TextStyle(color: Colors.green),
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(company, style: const TextStyle(color: Colors.black54)),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // right column: salary + apply
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  salary,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                OutlinedButton(onPressed: () {}, child: const Text('Details')),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
