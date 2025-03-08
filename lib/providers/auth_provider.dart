import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malhaeboredo/data/repositories/auth_repository.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final userInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authRepo = ref.read(authRepositoryProvider);
  return await authRepo.getUserInfo();
});
