import '../../../core/services/api_service.dart';
import '../../../data/models/contract.dart';

class ContractService {
  final ApiService _api = ApiService();

  Future<List<Contract>> getActiveContracts() async {
    try {
      final response = await _api.get('/contracts/active');
      return (response.data as List)
          .map((json) => Contract.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch active contracts';
    }
  }

  Future<List<Contract>> getArchivedContracts() async {
    try {
      final response = await _api.get('/contracts/archived');
      return (response.data as List)
          .map((json) => Contract.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch archived contracts';
    }
  }

  Future<Contract> createContract(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/contracts', data);
      return Contract.fromJson(response.data);
    } catch (e) {
      throw 'Failed to create contract';
    }
  }

  Future<void> archiveContract(int id) async {
    try {
      await _api.put('/contracts/$id/archive', {});
    } catch (e) {
      throw 'Failed to archive contract';
    }
  }

  Future<String> downloadContract(int id) async {
    try {
      final response = await _api.get('/contracts/$id/download');
      return response.data['downloadUrl'];
    } catch (e) {
      throw 'Failed to download contract';
    }
  }
}