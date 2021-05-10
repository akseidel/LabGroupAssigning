
void setPoolSize(){
poolSize = numCombOfKinN(gSize, classSize);
}

// Returns number of combinations of k members that can be chosen
// from a population of n members. Combinations with different order
// are considered the same combination.
public static long numCombOfKinN(int k, int n) {
  long result = factorial(n)/(factorial(k)*factorial(n-k));
  return result;
}

// Returns the factorial of a number
public static long factorial(long number) {
  if (number <= 1) return 1;
  else return number * factorial(number - 1);
}
