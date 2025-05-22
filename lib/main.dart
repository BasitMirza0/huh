import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: GmailHomePage()),
    );
  }
}

class GmailHomePage extends StatefulWidget {
  const GmailHomePage({super.key});

  @override
  State<GmailHomePage> createState() => _GmailHomePageState();
}

class _GmailHomePageState extends State<GmailHomePage> {
  bool _isDrawerOpen = false;

  String _selectedDate = 'Any time';
  String _selectedLabel = 'All labels';

  void _showSearchFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Text(
                        'Search filters',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red.shade800),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchField('From:', 'name@example.com'),
                        _buildSearchField('To:', 'name@example.com'),
                        _buildSearchField('Subject:', 'Enter subject keywords'),
                        const SizedBox(height: 16),
                        const Text('Include in search:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                        const SizedBox(height: 8),
                        _buildCheckboxOption('Has attachment', 'Find emails with files'),
                        _buildCheckboxOption('Is unread', 'Show only unread messages'),
                        _buildCheckboxOption('Is starred', 'Show starred messages'),
                        _buildCheckboxOption('Has calendar invite', 'Include meeting requests'),
                        const SizedBox(height: 16),
                        _buildDateSelector('Date within'),
                        const SizedBox(height: 16),
                        _buildLabelSelector('Select label'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Text('SEARCH'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.red.shade400, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
            activeColor: Colors.red.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(String title) {
    final options = [
      'Any time',
      'Past hour',
      'Past 24 hours',
      'Past week',
      'Past month',
      'Past year',
      'Custom range',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDate,
              items: options.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => _selectedDate = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelSelector(String title) {
    final labels = [
      'All labels',
      'Primary',
      'Social',
      'Promotions',
      'Updates',
      'Important',
      'Starred',
      'Sent',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedLabel,
              items: labels.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => setState(() => _selectedLabel = value!),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = 280;

    return DefaultTabController(
      length: 4,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 56,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black54),
                    onPressed: () => setState(() => _isDrawerOpen = !_isDrawerOpen),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: 40,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.search, color: Colors.black54, size: 20),
                        ),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Search in mail',
                              hintStyle: TextStyle(color: Colors.black54),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune, size: 20, color: Colors.black54),
                          onPressed: _showSearchFilterDialog,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              bottom: const TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.red,
                labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                tabs: [
                  Tab(text: 'Primary'),
                  Tab(text: 'Promotions'),
                  Tab(text: 'Social'),
                  Tab(text: 'Updates'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                EmailList(category: "Primary"),
                EmailList(category: "Promotions"),
                EmailList(category: "Social"),
                EmailList(category: "Updates"),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined, color: Colors.red),
              label: const Text('Compose', style: TextStyle(color: Colors.red)),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          if (_isDrawerOpen)
            GestureDetector(
              onTap: () => setState(() => _isDrawerOpen = false),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isDrawerOpen ? 0 : -drawerWidth,
            top: 0,
            bottom: 0,
            width: drawerWidth,
            child: Material(
              color: Colors.white,
              child: SafeArea(child: _buildDrawerContent()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text("Gmail", style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w500)),
        ),
        const Divider(height: 1),
        _buildDrawerItem(Icons.inbox, 'Inbox', true, '122'),
        _buildDrawerItem(Icons.star_outline, 'Starred', false),
        _buildDrawerItem(Icons.access_time, 'Snoozed', false),
        _buildDrawerItem(Icons.send, 'Sent', false),
        _buildDrawerItem(Icons.description_outlined, 'Drafts', false),
        _buildDrawerItem(Icons.expand_more, 'More', false),
        const Divider(height: 1),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Labels', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              Icon(Icons.add, size: 20),
            ],
          ),
        ),
        _buildDrawerItem(Icons.label_outline, 'Important', false),
        _buildDrawerItem(Icons.chat_outlined, 'Chats', false),
        _buildDrawerItem(Icons.schedule_send_outlined, 'Scheduled', false),
        _buildDrawerItem(Icons.label_important_outline, 'Promotions', false),
        _buildDrawerItem(Icons.forum_outlined, 'Forums', false),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, [String? count]) {
    return ListTile(
      dense: true,
      selected: isSelected,
      selectedTileColor: Colors.red.shade100,
      leading: Icon(icon, color: isSelected ? Colors.red : Colors.black87, size: 20),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.red : Colors.black87, fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal),
      ),
      trailing: count != null ? Text(count, style: TextStyle(color: isSelected ? Colors.red : Colors.black54, fontSize: 12)) : null,
      onTap: () {},
    );
  }
}

class EmailList extends StatelessWidget {
  final String category;

  const EmailList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 80),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SimpleEmailTile(
              sender: "$category Sender ${index + 1}",
              subject: "$category Email Subject ${index + 1}",
              preview: "This is a quick preview of the email...",
              time: "${(index % 12) + 1}:${(index * 5) % 60 < 10 ? '0' : ''}${(index * 5) % 60} ${index % 2 == 0 ? 'PM' : 'AM'}",
              avatarColor: Colors.primaries[index % Colors.primaries.length],
            ),
            if (index < 14) const Divider(height: 1, indent: 72),
          ],
        );
      },
    );
  }
}

class SimpleEmailTile extends StatelessWidget {
  final String sender;
  final String subject;
  final String preview;
  final String time;
  final Color avatarColor;

  const SimpleEmailTile({
    super.key,
    required this.sender,
    required this.subject,
    required this.preview,
    required this.time,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8).copyWith(left: 16, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: avatarColor,
              child: Text(sender[0], style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(sender, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis),
                    ),
                    Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(subject, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Text(preview, style: const TextStyle(color: Colors.black54, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 2),
              child: Icon(Icons.star_border, size: 18, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
