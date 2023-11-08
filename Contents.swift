import Foundation

var randomNumber1 = Int.random(in: 1...10)
var randomNumber2 = Int.random(in: 1...10)

while randomNumber2 == randomNumber1 {
    randomNumber2 = Int.random(in: 1...10)
}

func factorial(number: Int) -> Int {
    var product = 1
    for num in 1...number {
        product *= num
    }
    return product
}

func asyncFactorial(number: Int, closure: @escaping (Int) -> Void) {
    DispatchQueue.global().async(execute: {
        let product = factorial(number: number)
        closure(product)
    })
}

let group = DispatchGroup()

var winner = ""

group.enter()
asyncFactorial(number: randomNumber1) { product in
    if winner.isEmpty {
        winner = "first thread"
    }
    print("factorial of \(randomNumber1): \(product)")
    group.leave()
}

group.enter()
asyncFactorial(number: randomNumber2) { product in
    if winner.isEmpty {
        winner = "second thread"
    }
    print("factorial of \(randomNumber2): \(product)")
    group.leave()
}

group.notify(queue: .main) {
    print("Winner: \(winner)")
}

