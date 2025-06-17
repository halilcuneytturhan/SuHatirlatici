import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<AuthResponse?> signUp(String email, String password) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      print("✅ Supabase signUp response: ${response.user?.id}");
      return response;
    } catch (e, stack) {
      print("❌ Supabase signUp error: $e");
      print("📍 STACK TRACE: $stack");
      return null;
    }
  }

  static Future<AuthResponse?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print("✅ Supabase signIn response: ${response.user?.id}");
      return response;
    } catch (e, stack) {
      print("❌ Supabase signIn error: $e");
      print("📍 STACK TRACE: $stack");
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
      print("✅ Supabase signOut success");
    } catch (e, stack) {
      print("❌ Supabase signOut error: $e");
      print("📍 STACK TRACE: $stack");
    }
  }

  static bool isLoggedIn() {
    return client.auth.currentUser != null;
  }

  static User? getCurrentUser() {
    return client.auth.currentUser;
  }

  static Future<void> upsertUserProfile({
    required String userId,
    required String email,
    required double dailyGoal,
  }) async {
    try {
      await client.from('user_profiles').upsert({
        'id': userId,
        'email': email,
        'daily_goal': dailyGoal,
      });
      print("✅ User profile upserted for $userId");
    } catch (e, stack) {
      print("❌ Upsert profile error: $e");
      print("📍 STACK TRACE: $stack");
    }
  }

  static Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      final response =
          await client
              .from('user_profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();
      print("✅ User profile fetched for $userId");
      return response;
    } catch (e, stack) {
      print("❌ Fetch profile error: $e");
      print("📍 STACK TRACE: $stack");
      return null;
    }
  }

  static Future<double> fetchDailyWater(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final response = await client
          .from('water_logs')
          .select('amount')
          .eq('user_id', userId)
          .eq('date', today);

      final total = response.fold<double>(
        0,
        (sum, item) => sum + (item['amount'] as num).toDouble(),
      );
      print("✅ Daily water fetched: $total ml");
      return total;
    } catch (e, stack) {
      print("❌ Fetch water logs error: $e");
      print("📍 STACK TRACE: $stack");
      return 0;
    }
  }

  static Future<void> logWater(String userId, double amount) async {
    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      await client.from('water_logs').insert({
        'user_id': userId,
        'amount': amount,
        'date': today,
      });
      print("✅ Water log inserted: $amount ml for $userId");
    } catch (e, stack) {
      print("❌ Insert water log error: $e");
      print("📍 STACK TRACE: $stack");
    }
  }
}
