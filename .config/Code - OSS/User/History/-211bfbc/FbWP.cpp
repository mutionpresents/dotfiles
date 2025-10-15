// Linear (sequential) search
#include <iostream>
using namespace std;

int main() {
    int num[] = {1, 2, 3, 4, 5};
    int numsearch;
    int selected_num = -1; // placeholder in case the number isn't found

    cout << "Enter a number you want to search for in the array (1 to 5): ";
    cin >> numsearch;

    bool found = false; // flag to track if the number is found

    for (int i = 0; i < 5; i++) {
        if (num[i] == numsearch) {  // compare values, not index!
            selected_num = num[i];
            found = true;
            break; // stop searching once found
        }
    }

    if (found)
        cout << "Your number " << selected_num << " was found in the array." << endl;
    else
        cout << "Number not found in the array." << endl;

    return 0;
}
