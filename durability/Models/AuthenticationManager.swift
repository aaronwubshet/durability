import Foundation
import SwiftUI
import AuthenticationServices
import Supabase

@MainActor
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared.client
    
    private init() {}
    
    // MARK: - Apple Sign In
    
    func signInWithApple() async {
        isLoading = true
        errorMessage = nil
        
        NSLog("🍎 Starting Apple Sign In...")
        
        do {
            // Create Apple Sign In request
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            // Perform the request
            let result = try await withCheckedThrowingContinuation { continuation in
                let controller = ASAuthorizationController(authorizationRequests: [request])
                let delegate = AppleSignInDelegate { result in
                    continuation.resume(with: result)
                }
                controller.delegate = delegate
                controller.presentationContextProvider = delegate
                controller.performRequests()
                
                // Store delegate reference to prevent deallocation
                objc_setAssociatedObject(controller, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)
            }
            
            // Handle the result
            if let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential {
                await handleAppleSignInResult(credential: appleIDCredential)
            } else {
                throw AuthError.invalidCredential
            }
            
        } catch {
            NSLog("❌ Apple Sign In failed: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func handleAppleSignInResult(credential: ASAuthorizationAppleIDCredential) async {
        NSLog("🍎 Processing Apple Sign In result...")
        
        do {
            // Extract user info
            let email = credential.email ?? ""
            let fullName = credential.fullName
            let identityToken = credential.identityToken
            
            guard let identityToken = identityToken,
                  let tokenString = String(data: identityToken, encoding: .utf8) else {
                throw AuthError.invalidToken
            }
            
            NSLog("📧 User email: \(email)")
            NSLog("👤 User name: \(fullName?.givenName ?? "unknown") \(fullName?.familyName ?? "unknown")")
            
            // Sign in with Supabase using Apple token
            let authResponse = try await supabase.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple,
                    idToken: tokenString
                )
            )
            
            NSLog("✅ Supabase authentication successful!")
            
            // Create or update user profile
            await createOrUpdateUserProfile(
                userId: authResponse.user.id,
                email: email,
                firstName: fullName?.givenName,
                lastName: fullName?.familyName
            )
            
            isLoading = false
            
        } catch {
            NSLog("❌ Apple Sign In processing failed: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Email/Password Authentication
    
    func signUp(email: String, firstName: String, lastName: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        NSLog("📧 Starting email/password sign up...")
        
        do {
            // Sign up with Supabase
            let authResponse = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            NSLog("✅ Email/password sign up successful!")
            
            // Create user profile
            await createOrUpdateUserProfile(
                userId: authResponse.user.id,
                email: email,
                firstName: firstName,
                lastName: lastName
            )
            
            isLoading = false
            
        } catch {
            NSLog("❌ Email/password sign up failed: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        NSLog("📧 Starting email/password sign in...")
        
        do {
            // Sign in with Supabase
            let authResponse = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            NSLog("✅ Email/password sign in successful!")
            
            // Load existing user profile
            await loadUserProfile(userId: authResponse.user.id)
            
            isLoading = false
            
        } catch {
            NSLog("❌ Email/password sign in failed: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func loadUserProfile(userId: UUID) async {
        NSLog("👤 Loading user profile for user ID: \(userId)")
        
        do {
            let profile = try await supabase
                .from("profiles")
                .select("*")
                .eq("id", value: userId)
                .single()
                .execute()
            
            if let profileData = try? JSONDecoder().decode(ProfileData.self, from: profile.data) {
                NSLog("✅ User profile loaded successfully")
                // Update the published properties if needed
                // For now, we'll just log the success
            } else {
                NSLog("ℹ️ No user profile found for ID: \(userId)")
            }
        } catch {
            NSLog("❌ Error loading user profile: \(error)")
        }
    }
    
    // MARK: - User Profile Management
    
    private func createOrUpdateUserProfile(userId: UUID, email: String, firstName: String?, lastName: String?) async {
        NSLog("👤 Creating/updating user profile...")
        
        do {
            let profileData = ProfileData(
                id: userId,
                email: email,
                first_name: firstName,
                last_name: lastName,
                created_at: Date(),
                updated_at: Date()
            )
            
            // Try to insert new profile, if it fails (exists), update it
            do {
                let _ = try await supabase
                    .from("profiles")
                    .insert(profileData)
                    .execute()
                
                NSLog("✅ New user profile created!")
                
            } catch {
                // Profile might already exist, try to update
                NSLog("ℹ️ Profile might exist, attempting update...")
                
                let _ = try await supabase
                    .from("profiles")
                    .update(profileData)
                    .eq("id", value: userId)
                    .execute()
                
                NSLog("✅ User profile updated!")
            }
            
        } catch {
            NSLog("❌ Profile creation/update failed: \(error)")
        }
    }
}

// MARK: - Supporting Types

struct ProfileData: Codable {
    let id: UUID
    let email: String
    let first_name: String?
    let last_name: String?
    let created_at: Date
    let updated_at: Date
}

enum AuthError: Error, LocalizedError {
    case invalidCredential
    case invalidToken
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid credentials provided"
        case .invalidToken:
            return "Invalid authentication token"
        case .networkError:
            return "Network connection error"
        }
    }
}

// MARK: - Apple Sign In Delegate

class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private let completion: (Result<ASAuthorization, Error>) -> Void
    
    init(completion: @escaping (Result<ASAuthorization, Error>) -> Void) {
        self.completion = completion
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        completion(.success(authorization))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
} 