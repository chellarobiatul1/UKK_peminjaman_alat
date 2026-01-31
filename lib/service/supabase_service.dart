import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://xcftkysegntxwojwjmgu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhjZnRreXNlZ250eHdvandqbWd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg0MjQxOTYsImV4cCI6MjA4NDAwMDE5Nn0.YpSe-7i8E3PpcUzT_tQ3prVNIEVsad-_s2-a_R3ShYU',
    );
  }
}