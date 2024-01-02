access(all) contract FooContract {
    access(all) let specialNumbers: {Int: String}

    init() {
        // https://sites.google.com/site/mathematicsmiscellany/very-special-numbers
        self.specialNumbers = {
            1729: "Harshad",
            8128: "Harmonic",
            41041: "Carmichael"
        }
    }

    access(all)
    fun addSpecialNumber(_ n: Int, _ trait: String) {
        self.specialNumbers[n] = trait
    }

    access(all)
    fun getIntegerTrait(_ n: Int): String {
        if n < 0 {
            return "Negative"
        } else if n == 0 {
            return "Zero"
        } else if n < 10 {
            return "Small"
        } else if n < 100 {
            return "Big"
        } else if n < 1000 {
            return "Huge"
        }

        if self.specialNumbers.containsKey(n) {
            return self.specialNumbers[n]!
        }

        return "Enormous"
    }

}
