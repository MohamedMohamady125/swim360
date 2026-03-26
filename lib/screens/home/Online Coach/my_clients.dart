import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swim360/core/api/api_config.dart';
import 'package:swim360/core/services/storage_service.dart';

class MyClientsScreen extends StatefulWidget {
  const MyClientsScreen({super.key});

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {
  final StorageService _storageService = StorageService();
  List<Client> _clients = [];
  bool _isLoading = true;

  List<Client> _filteredClients = [];
  String _searchQuery = '';
  Client? _selectedClient;
  bool _showModal = false;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> _loadClients() async {
    setState(() => _isLoading = true);
    try {
      final headers = await _getHeaders();

      // First get coach's programs
      final user = await _storageService.getUser();
      final programsUri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/programs')
          .replace(queryParameters: {'provider_id': user?.id ?? ''});
      final programsResponse = await http.get(programsUri, headers: headers);

      if (programsResponse.statusCode == 200) {
        final List<dynamic> programs = jsonDecode(programsResponse.body);
        final List<Client> allClients = [];

        // For each program, get enrollments
        for (final program in programs) {
          final programId = program['id'];
          final programName = program['program_name'] ?? program['title'] ?? 'Unknown';

          try {
            final enrollUri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/programs/$programId/enrollments');
            final enrollResponse = await http.get(enrollUri, headers: headers);

            if (enrollResponse.statusCode == 200) {
              final List<dynamic> enrollments = jsonDecode(enrollResponse.body);
              for (final enrollment in enrollments) {
                final clientName = enrollment['user_name'] ?? enrollment['full_name'] ?? 'Unknown';
                allClients.add(Client(
                  id: enrollment['id'] ?? enrollment['user_id'] ?? '',
                  name: clientName,
                  program: programName,
                  endDate: enrollment['end_date'] ?? 'Ongoing',
                  phone: enrollment['phone_number'] ?? enrollment['phone'] ?? '',
                  age: enrollment['age'] ?? 0,
                  gender: enrollment['gender'] ?? 'N/A',
                  initial: clientName.isNotEmpty ? clientName[0].toUpperCase() : '?',
                ));
              }
            }
          } catch (_) {
            // Skip programs where enrollment fetch fails
          }
        }

        setState(() {
          _clients = allClients;
          _filteredClients = allClients;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredClients = _clients.where((c) =>
        c.name.toLowerCase().contains(query.toLowerCase()) ||
        c.program.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  Map<String, List<Client>> get _groupedClients {
    final Map<String, List<Client>> groups = {};
    for (var client in _filteredClients) {
      groups.putIfAbsent(client.program, () => []).add(client);
    }
    return groups;
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                              ),
                              child: const Icon(Icons.arrow_back_ios_new, size: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MY CLIENTS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                              SizedBox(height: 2),
                              Text('MANAGEMENT HUB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFDCEEFE)),
                        ),
                        child: const Icon(Icons.people, color: Color(0xFF2563EB), size: 24),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                  ),
                  child: TextField(
                    onChanged: _handleSearch,
                    decoration: InputDecoration(
                      hintText: 'Search clients or programs...',
                      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),

                // Client List
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
                      : _filteredClients.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No clients yet',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                    padding: const EdgeInsets.all(24),
                    children: _groupedClients.entries.map((entry) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${entry.key.toUpperCase()} (${entry.value.length})',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFD1D5DB), letterSpacing: 3.0),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(child: Divider(color: Color(0xFFF3F4F6))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...entry.value.map((client) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () => setState(() {
                                _selectedClient = client;
                                _showModal = true;
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(color: const Color(0xFFF3F4F6)),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFFDCEEFE)),
                                      ),
                                      child: Center(
                                        child: Text(client.initial, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(client.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                                          const SizedBox(height: 4),
                                          Text('Ends: ${client.endDate}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB), letterSpacing: 3.0)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.visibility, color: Color(0xFF9CA3AF), size: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(height: 32),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Client Detail Modal
          if (_showModal && _selectedClient != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showModal = false),
                child: Container(
                  color: const Color(0xFF0F172A).withOpacity(0.6),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () => setState(() => _showModal = false),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: const Color(0xFFDCEEFE)),
                              ),
                              child: const Icon(Icons.person, color: Color(0xFF2563EB), size: 40),
                            ),
                            const SizedBox(height: 16),
                            Text(_selectedClient!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text(_selectedClient!.program.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('AGE / GENDER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                      Text('${_selectedClient!.age} YRS • ${_selectedClient!.gender}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                  const Divider(height: 24, color: Color(0xFFE5E7EB)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('PROGRAM END', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 3.0)),
                                      Text(_selectedClient!.endDate, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () => _launchWhatsApp(_selectedClient!.phone),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF25D366),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble, color: Colors.white, size: 24),
                                    SizedBox(width: 12),
                                    Text('WHATSAPP CHAT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Client {
  final String id;
  final String name;
  final String program;
  final String endDate;
  final String phone;
  final int age;
  final String gender;
  final String initial;

  Client({
    required this.id,
    required this.name,
    required this.program,
    required this.endDate,
    required this.phone,
    required this.age,
    required this.gender,
    required this.initial,
  });
}
