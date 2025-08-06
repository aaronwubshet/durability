import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Config.supabaseURL)!,
            supabaseKey: Config.supabaseAnonKey
        )
    }
    
    func testConnection() async {
        NSLog("🔍 Testing Supabase connection...")
        
        do {
            let response = try await client
                .from("profiles")
                .select("count")
                .execute()
            
            NSLog("✅ Supabase connection successful!")
            NSLog("📊 Response: \(response)")
            
        } catch {
            NSLog("❌ Supabase connection failed: \(error)")
            NSLog("🔧 Error details: \(error.localizedDescription)")
        }
    }
    
    func checkDatabaseSchema() async {
        NSLog("🔍 Checking database schema...")
        
        // Test different tables to see what exists
        let tablesToTest = ["profiles", "assessment_results", "joint_metrics", "movement_metrics", "injuries", "goals", "training_sessions"]
        
        for table in tablesToTest {
            do {
                let _ = try await client
                    .from(table)
                    .select("count")
                    .execute()
                
                NSLog("✅ Table '\(table)' exists!")
                
            } catch {
                NSLog("❌ Table '\(table)' does not exist or is not accessible: \(error.localizedDescription)")
            }
        }
    }
    
    func testProfilesTable() async {
        NSLog("🔍 Testing profiles table structure...")
        
        do {
            // Try to get a sample record to see the structure
            let response = try await client
                .from("profiles")
                .select("*")
                .limit(1)
                .execute()
            
            NSLog("✅ Profiles table structure: \(response)")
            
        } catch {
            NSLog("❌ Profiles table test failed: \(error)")
        }
    }
    
    func testTableInsertions() async {
        NSLog("🔍 Testing table insertions...")
        
        // Test inserting into assessment_results (this will fail without auth, but we can test the table structure)
        do {
            let testData = AssessmentTestData(
                durability_score: 75.5,
                range_of_motion: 0.8,
                flexibility: 0.7,
                mobility: 0.75,
                functional_strength: 0.8,
                aerobic_capacity: 0.7
            )
            
            let _ = try await client
                .from("assessment_results")
                .insert(testData)
                .execute()
            
            NSLog("✅ Assessment results table insertion test successful!")
            
        } catch {
            NSLog("ℹ️ Assessment results insertion test (expected to fail without auth): \(error.localizedDescription)")
        }
        
        // Test inserting into joint_metrics
        do {
            let testData = JointMetricTestData(
                joint_name: "left_knee",
                metric_type: "range_of_motion",
                metric_name: "flexion_angle",
                value: 120.5,
                unit: "degrees"
            )
            
            let _ = try await client
                .from("joint_metrics")
                .insert(testData)
                .execute()
            
            NSLog("✅ Joint metrics table insertion test successful!")
            
        } catch {
            NSLog("ℹ️ Joint metrics insertion test (expected to fail without auth): \(error.localizedDescription)")
        }
    }
}

// MARK: - Test Data Structures

struct AssessmentTestData: Codable {
    let durability_score: Double
    let range_of_motion: Double
    let flexibility: Double
    let mobility: Double
    let functional_strength: Double
    let aerobic_capacity: Double
}

struct JointMetricTestData: Codable {
    let joint_name: String
    let metric_type: String
    let metric_name: String
    let value: Double
    let unit: String
} 