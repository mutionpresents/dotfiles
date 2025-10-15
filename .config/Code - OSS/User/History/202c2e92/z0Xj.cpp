#include <iostream>

using namespace std;

// if given the following code:

/*
struct Point
{
    int x;
    int y;
};
*/

// Write statements that
// A. define a Point structure variable named center.
// B. assign 12 to the x member of center.
// C. assign 7 to the y member of center.
// D. display the contents of the x and y members of center.

// A. Point center;
// B. center.x = 12
// C. center.y = 7;
// D. cout << center.x << " " << center.y << endl;

struct Point {
  int x;
  int y;
};

int main() {
  // A. Define point structure variable named center
  Point center;

  // B. assign 12 to the x member of center
  center.x = 12;

  // C. assign 7 to the y member of center
  center.y = 7;

  // D. display them.
  cout << center.x << " " << center.y << endl;
}