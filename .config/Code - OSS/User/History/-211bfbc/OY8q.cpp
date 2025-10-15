// linear (sequential) search
#include <iostream>

using namespace std;

int main(){
    int num[] = {1,2,3,4,5};

    int numsearch = 0;
    // Search for a number
    cout << "Enter a number you want to search for in the array";
    cout << " between 1 to 5."<<endl;
    cout << "Enter the number: ";
    cin >> numsearch;

    while (i=0;i<=4;i++){
        if (i=num[i]){
            selected_num = num[i];
        }
        else{
            return 0;
        }

    }

    cout << "Your number is " << selected_num << ".";
}