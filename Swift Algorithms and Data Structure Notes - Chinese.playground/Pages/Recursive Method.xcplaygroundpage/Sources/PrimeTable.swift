import Foundation

public struct PrimeTable {
	static var primes: [Int] = [2,3]
	public static func primeTable(n: Int) -> [Int] {
		guard n > primes.last else { return primes }
		func isPrime(number: Int) -> Bool {
			for prime in primes {
				guard !(prime * prime > number) else { break }
				if number % prime == 0 {
					return false
				}
			}
			return true
		}
		for i in primes.last! + 1 ... n {
			if isPrime(i) {
				primes.append(i)
			}
		}
		return primes
	}
	enum InputError: ErrorType {
		case Negative
		case RangeErr
	}
	public static func primeTable(from: Int, to n: Int) throws -> [Int] {
		guard from > 1 && n > 1 else { throw InputError.Negative }
		guard from < n else { throw InputError.RangeErr }
		guard n > primes.last else { return primes.filter{ $0 >= from && $0 <= n } }
		primeTable(n)
		return primes.filter{ $0 >= from && $0 <= n }
	}
}