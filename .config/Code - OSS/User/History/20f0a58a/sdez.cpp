// Jeremiah Park
// CSCI 230
// 07 October 2025
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int main() {
  // Define a string with 5 names.
  vector<string> names = {"Tom", "Omar", "Mary", "Mickey", "Donald"}

  // Ask user for 5 other names to be added to the vector
  // via for loop
  for (int i = 0; i <= 4; i++) {
    // string variable to store the new names
    string updatedName;
    cout << "Enter the #(i+1) name to add to the list: ";
    cin >> updatedName;

    // Insert the names to the end of the vector using the
    // insert function
    names.insert(names.end(), updatedName)
  }

  // Seperate loop to print out all the names on seperate lines.

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