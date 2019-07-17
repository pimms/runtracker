import Foundation

class SeedableRNG: RandomNumberGenerator {
    var seed: Int

    init(seed: Int) {
        self.seed = seed
    }

    func next() -> UInt64 {
        let a = 1103515245
        let c = 12345
        let m = 2 << 30

        seed = (a * seed + c) % m
        return UInt64(seed)
    }
}
