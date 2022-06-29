/*
Program to convert integers of any base between 2 and 62
*/

#include <iostream>
#include <string>
#include <cmath>
using namespace std;

string basetobase(string,int,int);
string dtof(string);

int main(void){
	string usrin;
	const string dig = {"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"};
	cout << "Last digit of B1, Last digit of B2>>";
	getline(cin,usrin);

	//Set variables from user input
	int ogbase = dig.find(usrin[0])+1;
	int newbase = dig.find(usrin[2])+1;
	usrin.erase(0,2);

	while(true){
		cout << "Number>> ";
		getline(cin,usrin);
		cout << basetobase(usrin, ogbase, newbase) << "\n";
	}
}

string basetobase(string ognum, int ogbase, int newbase){
	//Set background variables
	const string dig = {"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"};
	int temp[ognum.length()] = {0};
	unsigned long long int num = 0;

	//Convert each digit to its binary representation
	for(int i = 0; i < ognum.length(); i++){
		temp[i] = dig.find(ognum[i]);
		if(temp[i] == -1){
			cout << "Digit number " << i+1 << " invalid digit in base " << ogbase << ".\n";
			break;
		}
	}

	//convert whole number to its binary representation
	for(int i = 0; i < ognum.length(); i++){num = ((num + temp[i])*ogbase);}
	num /= ogbase;

	//convert whole number from binary into new base
	int newnum[1000] = {0};
	int n = 999;
	while(num != 0){
		newnum[n] = num % newbase;
		num = (num-newnum[n])/newbase;
		n--;
	}

	//Convert each digit from binary to its new base
	string newnumber = {};
	for(int i = 0; i < 1000; i++){newnumber += dig[newnum[i]];}

	//remove leading zeros
	newnumber.erase(0,newnumber.find_first_not_of('0'));

	return newnumber;
}

string dtof(string decimal, int ogbase, int newbase){

	int n = decimal.length();
	n = pow(10,n);
	string num = decimal;
	string den = to_string(n);
	num = basetobase(num, ogbase, newbase);
	den = basetobase(den, ogbase, newbase);

	return num + "/" + den;
}
