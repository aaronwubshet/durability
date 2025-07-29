import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    // Types to read - using safe initialization
    var readTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = []
        
        if let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepCount)
        }
        if let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(activeEnergy)
        }
        if let distance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) {
            types.insert(distance)
        }
        if let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) {
            types.insert(heartRate)
        }
        
        return types
    }

    @Published var isAuthorized: Bool = false

    func checkAvailability() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard checkAvailability() else {
            DispatchQueue.main.async {
                completion(false, NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device"]))
            }
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                completion(success, error)
            }
        }
    }

    // Example: Fetch today's steps
    func fetchSteps(completion: @escaping (Double) -> Void) {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { 
            DispatchQueue.main.async {
                completion(0)
            }
            return 
        }
        
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let count = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(count)
            }
        }
        healthStore.execute(query)
    }

    // Add similar methods for other metrics as needed
} 