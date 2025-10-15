// Jeremiah Park
// CSCI 230
// 07 October 2025
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int main() {
  // Define a string with 5 names.
  vector<string> names = {1, 2, 3, 4, 5};

  // Define an iterator pointing to the 2nd element.
  auto it = numbers.begin() + 1;

  // Insert a new element with the value 99.
  numbers.insert(it, 99);

  // Display the vector elements.
  for (auto element : numbers)
    cout << element << " ";
  cout << endl;

  return 0;
}