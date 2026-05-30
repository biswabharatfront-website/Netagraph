import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://zvcaisaagjvsbtkptezc.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2Y2Fpc2FhZ2p2c2J0a3B0ZXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAxMzY0MjgsImV4cCI6MjA5NTcxMjQyOH0.KIFDuH61hwFHXdhWb-61yN1BGH-s-BISwGK4X_FxyE0';

  /// Initialize Supabase — call once in main() before runApp()
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Convenient getter for the Supabase client
  static SupabaseClient get client => Supabase.instance.client;
}
