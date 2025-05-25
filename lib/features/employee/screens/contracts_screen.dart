import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/contract.dart';
import '../providers/contract_provider.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() =>
        Provider.of<ContractProvider>(context, listen: false).loadContracts());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContractProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contracts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Archived'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContractDialog(context),
        child: const Icon(Icons.add),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search contracts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      // Optional: implement search logic here
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _ContractsList(
                        contracts: provider.activeContracts,
                        isArchived: false,
                      ),
                      _ContractsList(
                        contracts: provider.archivedContracts,
                        isArchived: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _showAddContractDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contract'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Contract Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Add form handling and call createContract()
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class _ContractsList extends StatelessWidget {
  final List<Contract> contracts;
  final bool isArchived;

  const _ContractsList({
    required this.contracts,
    required this.isArchived,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContractProvider>(context, listen: false);

    if (contracts.isEmpty) {
      return const Center(child: Text('No contracts found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];

        return Card(
          child: ListTile(
            title: Text(contract.contractType),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Date: ${contract.startDate.toLocal().toIso8601String().split('T').first}'),
                Text('End Date: ${contract.endDate.toLocal().toIso8601String().split('T').first}'),
              ],
            ),
            trailing: isArchived
                ? IconButton(
                    icon: const Icon(Icons.restore),
                    onPressed: () {
                      // TODO: Implement restore functionality
                    },
                  )
                : PopupMenuButton(
                    onSelected: (value) async {
                      if (value == 'archive') {
                        await provider.archiveContract(contract.id);
                      } else if (value == 'download') {
                        final url = await provider.downloadContract(contract.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Download URL: $url')),
                        );
                      } else if (value == 'view') {
                        // TODO: Implement view details
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Text('View Details'),
                      ),
                      const PopupMenuItem(
                        value: 'download',
                        child: Text('Download PDF'),
                      ),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
