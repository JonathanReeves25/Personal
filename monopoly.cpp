#include <iostream>
#include <iomanip>
#include <string>
using namespace std;

int roll(void);
void shuffle(int[],int);

int main(int argc, char* argv[]){
	srand(time(NULL));

	int space = 0, rolla, rollb, jail = 0;
	int spaces[40] = {0};
	float spacepers[40] = {0};
	int chance[16] = {0,24,11,1228,5152535,-3,30,5,39,-1,-1,-1,-1,-1,-1,-1}, chancen = 0;
	int cchest[16] = {30,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}, cchestn = 0;

	for(int i = 0; i < atoi(argv[1]); i++){
		if(chancen == 16){shuffle(chance,16); chancen = 0;}
		if(cchestn == 16){shuffle(cchest,16); cchestn = 0;}
		rolla = roll(); rollb = roll(); space += (rolla+rollb);
		if(40 < space){space -= 40;}
		if(rolla == rollb){jail++;} else{jail = 0;}
		if(jail == 3){space == 30; jail = 0;}
		else if(space == 2 || space == 17 || space == 33){
			if(cchest[cchestn] == 0){space == 0;}
			else if(cchest[cchestn] == 30){space == 30;}
			cchestn++;
		}
		else if(space == 7 || space == 22 || space == 36){
			if(chance[chancen] == 0){space = 0;}
			else if(chance[chancen] == 24){space = 24;}
			else if(chance[chancen] == 11){space = 11;}
			else if(chance[chancen] == 1228){
				if(space == 7 || space == 33){space = 12;}
				else if(space == 22){space = 28;}
			}
			else if(chance[chancen] == 5152535){
				if(space == 7){space = 15;}
				else if(space == 22){space = 25;}
				else if(space == 36){space = 5;}
			}
			else if(chance[chancen] == 30){space = 30;}
			else if(chance[chancen] == 5){space = 5;}
			else if(chance[chancen] == 39){space = 39;}
			else if(chance[chancen] == -3){space -= 3;}
			chancen++;
		}
		spaces[space] += 1;
		if(space == 30){space = 10;}
	}
	for(int i = 0; i < 40; i++){
		spacepers[i] = spaces[i]*100/atof(argv[1]);
		cout << setprecision(2) << i << ": " << fixed << setw(4) << setfill('0') << spacepers[i] << "%\n";
	}
}

int roll(void){
	return (rand() % 6) + 1;
}

void shuffle(int* a, int length){
	int b, c;
	for(int i = 0; i < 100; i++){
		b = rand()%(length - 1), c = 0;
		c = a[b+1];
		a[b+1] = a[b];
		a[b] = c;
	}
}
