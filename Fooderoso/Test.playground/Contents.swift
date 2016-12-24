//: Playground - noun: a place where people can play

import UIKit

var array = ["oi", "ola", "hello"]

let range = Range(uncheckedBounds: (lower: 1, upper: 2))
array.replaceSubrange(range, with: ["tudo bem?"])

print(array)