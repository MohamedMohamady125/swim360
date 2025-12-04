import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Client {
    final String id;
    final String name;
    final String program;
    final String? endDate; // ISO yyyy-mm-dd or null
    final String phone;
    final int age;
    final String gender;
    final String initial;

    Client({
        required this.id,
        required this.name,
        required this.program,
        this.endDate,
        required this.phone,
        required this.age,
        required this.gender,
        required this.initial,
    });
}

class MyClientsScreen extends StatefulWidget {
    const MyClientsScreen({Key? key}) : super(key: key);

    @override
    State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {
    final TextEditingController _searchCtrl = TextEditingController();

    final List<Client> _allClients = [
        Client(id: 'c1', name: 'Alex Johnson', program: '12-Week Stroke Mastery', endDate: '2024-12-31', phone: '555-1234', age: 28, gender: 'Male', initial: 'A'),
        Client(id: 'c2', name: 'Sarah Chen', program: 'Nutrition for Triathletes', endDate: '2025-01-20', phone: '555-5678', age: 35, gender: 'Female', initial: 'S'),
        Client(id: 'c3', name: 'Mike Rodriguez', program: 'Beginner Open Water Prep', endDate: '2024-10-15', phone: '555-9012', age: 19, gender: 'Male', initial: 'M'),
        Client(id: 'c4', name: 'Laura Smith', program: '12-Week Stroke Mastery', endDate: '2025-03-15', phone: '555-3456', age: 41, gender: 'Female', initial: 'L'),
        Client(id: 'c5', name: 'David Lee', program: 'Nutrition for Triathletes', endDate: '2024-11-01', phone: '555-7777', age: 30, gender: 'Male', initial: 'D'),
        Client(id: 'c6', name: 'Emily White', program: '12-Week Stroke Mastery', endDate: '2024-11-15', phone: '555-8888', age: 22, gender: 'Female', initial: 'E'),
    ];

    String _query = '';

    @override
    void dispose() {
        _searchCtrl.dispose();
        super.dispose();
    }

    String _formatPhoneForWhatsApp(String raw) {
        final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleaned.length == 10 && !cleaned.startsWith('1')) return '1$cleaned';
        return cleaned;
    }

    Map<String, List<Client>> _groupedClients() {
        final filtered = _allClients.where((c) {
            final q = _query.toLowerCase().trim();
            if (q.isEmpty) return true;
            return c.name.toLowerCase().contains(q) || c.program.toLowerCase().contains(q);
        }).toList();

        final Map<String, List<Client>> groups = {};
        for (final c in filtered) {
            groups.putIfAbsent(c.program, () => []).add(c);
        }

        // Sort each group's clients by end date (soonest first)
        for (final key in groups.keys) {
            groups[key]!.sort((a, b) {
                final aMillis = a.endDate != null ? DateTime.tryParse(a.endDate!)?.millisecondsSinceEpoch ?? double.infinity.toInt() : double.infinity.toInt();
                final bMillis = b.endDate != null ? DateTime.tryParse(b.endDate!)?.millisecondsSinceEpoch ?? double.infinity.toInt() : double.infinity.toInt();
                return aMillis.compareTo(bMillis);
            });
        }

        return groups;
    }

    void _openClientDetails(Client client) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            builder: (context) {
                final wa = _formatPhoneForWhatsApp(client.phone);
                final waUrl = 'https://wa.me/$wa';
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(height: 6, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                        const SizedBox(height: 12),
                        CircleAvatar(radius: 36, backgroundColor: Colors.blue.shade400, child: Text(client.initial, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 12),
                        Text(client.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(client.program, style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 16),
                        ListTile(title: const Text('Phone Number'), subtitle: Text(client.phone), trailing: TextButton(onPressed: () async {
                            // Copy WhatsApp URL to clipboard as a safe default (no external dependency required)
                            await Clipboard.setData(ClipboardData(text: waUrl));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('WhatsApp link copied: $waUrl')));
                        }, child: const Text('Open WhatsApp'))),
                        const Divider(),
                        ListTile(title: const Text('Age'), trailing: Text('${client.age}')),
                        ListTile(title: const Text('Gender'), trailing: Text(client.gender)),
                        ListTile(title: const Text('Program End Date'), trailing: Text(client.endDate ?? 'N/A')),
                        const SizedBox(height: 12),
                        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { Navigator.pop(context); }, child: const Text('Close'))),
                        const SizedBox(height: 8),
                    ]),
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        final groups = _groupedClients();

        return Scaffold(
            appBar: AppBar(title: const Text('My Clients')),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                        const Align(alignment: Alignment.centerLeft, child: Text('View and manage the details of clients currently enrolled in your programs.', style: TextStyle(color: Colors.black54))),
                        const SizedBox(height: 12),
                        TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search clients or programs...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            onChanged: (v) => setState(() => _query = v),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                            child: groups.isEmpty
                                    ? Center(child: const Text('No clients found.'))
                                    : ListView.builder(
                                            itemCount: groups.keys.length,
                                            itemBuilder: (context, idx) {
                                                final programName = groups.keys.elementAt(idx);
                                                final clients = groups[programName]!;
                                                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Text('$programName (${clients.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                                    ),
                                                    ...clients.map((c) => Card(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                elevation: 1,
                                                                margin: const EdgeInsets.symmetric(vertical: 6),
                                                                child: ListTile(
                                                                    leading: CircleAvatar(backgroundColor: Colors.blue.shade400, child: Text(c.initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                                                    title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                                    subtitle: Text('Ends: ${c.endDate ?? 'Ongoing'}'),
                                                                    trailing: IconButton(icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.blue), onPressed: () => _openClientDetails(c)),
                                                                ),
                                                            )).toList(),
                                                ]);
                                            },
                                        ),
                        ),
                    ]),
                ),
            ),
        );
    }
}
