import 'package:flutter/foundation.dart';
import '../services/contract_service.dart';
import '../../../data/models/contract.dart';

class ContractProvider with ChangeNotifier {
  final ContractService _service = ContractService();
  List<Contract> _activeContracts = [];
  List<Contract> _archivedContracts = [];
  bool _loading = false;

  List<Contract> get activeContracts => _activeContracts;
  List<Contract> get archivedContracts => _archivedContracts;
  bool get loading => _loading;

  Future<void> loadContracts() async {
    _loading = true;
    notifyListeners();

    try {
      await Future.wait([
        _loadActiveContracts(),
        _loadArchivedContracts(),
      ]);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadActiveContracts() async {
    _activeContracts = await _service.getActiveContracts();
  }

  Future<void> _loadArchivedContracts() async {
    _archivedContracts = await _service.getArchivedContracts();
  }

  Future<void> createContract(Map<String, dynamic> data) async {
    try {
      final contract = await _service.createContract(data);
      _activeContracts.add(contract);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> archiveContract(int id) async {
    try {
      await _service.archiveContract(id);
      final contract = _activeContracts.firstWhere((c) => c.id == id);
      _activeContracts.removeWhere((c) => c.id == id);
      _archivedContracts.add(contract);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downloadContract(int id) async {
    try {
      return await _service.downloadContract(id);
    } catch (e) {
      rethrow;
    }
  }
}