import Foundation

actor HostThrottler {
	private let delay: UInt64 // nanoseconds
	private var last: [String: UInt64] = [:]
	init(delayMs: Int) { self.delay = UInt64(delayMs) * 1_000_000 }
	
	func waitTurn(for host: String) async {
		let now = DispatchTime.now().uptimeNanoseconds
		let earliest = (last[host] ?? 0) + delay
		if earliest > now { try? await Task.sleep(nanoseconds: earliest - now) }
		last[host] = DispatchTime.now().uptimeNanoseconds
	}
}

