// Misc. functions

void setPoolSize() {
  poolSize = numCombOfKinN(gSize, classSize);
}

// Returns number of combinations of k members that can be chosen
// from a population of n members. Combinations with different order
// are considered the same combination.
public static int numCombOfKinN(int k, int n) {
  int result = round(factorial(n)/(factorial(k)*factorial(n-k)));
  return result;
}

// Returns the factorial of a number. This needs to be a float.
public static float factorial(int number) {
  if (number <= 1) { 
    return 1;
  } else {
    return number * factorial(number - 1);
  }
}
