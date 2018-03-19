#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

// Auxiliar stuff goes here:

int numProp;
vector <int> NumTimes; //Conflict list: number of times a literal appears
vector <vector <int> > PosClauses; //Matrix of positive clauses
vector <vector <int> > NegClauses; //Matrix of negative clauses


void readClauses() {
	// Skip comments
	char c = cin.get();
	while (c == 'c') {
		while (c != '\n') c = cin.get();
		c = cin.get();
	}  
	
	// Read "cnf numVars numClauses"
	string aux;
	cin >> aux >> numVars >> numClauses;
	clauses.resize(numClauses);  
	
    //Read aux data
    numProp = 0;
	NumTimes = vector<int> (numVars+1, 1);
	PosClauses.resize(numVars+1);
	NegClauses.resize(numVars+1);
    
    
    // Read clauses
	for (uint i = 0; i < numClauses; ++i) {
		int lit;
		while (cin >> lit and lit != 0) {
            clauses[i].push_back(lit);
            uint Alit = abs(lit);
            ++NumTimes[Alit];
            if (lit >= 0) PosClauses[Alit].push_back(i);
            else          NegClauses[Alit].push_back(i);
        }
	}    
}



int currentValueInModel(int lit){
	if (lit >= 0) return model[lit];
	else {
		if (model[-lit] == UNDEF) return UNDEF;
		else return 1 - model[-lit];
	}
}


void setLiteralToTrue(int lit){
	modelStack.push_back(lit);
	if (lit > 0) model[lit] = TRUE;
	else model[-lit] = FALSE;   
}


bool propagateGivesConflict ( ) {
	while ( indexOfNextLitToPropagate < modelStack.size() ) {
        int litr = modelStack[indexOfNextLitToPropagate];
        ++indexOfNextLitToPropagate;
        
        vector <int> &aux = ((litr <= 0) ? PosClauses[-litr] :  NegClauses[litr]);
        
        
		for (uint i = 0; i < aux.size(); ++i) {
            int aux_idx = aux[i];
			bool someLitTrue = false;
			int lastLitUndef = 0;
			int numUndefs = 0;
			for (uint k = 0; not someLitTrue and k < clauses[aux_idx].size(); ++k){
				int val = currentValueInModel(clauses[aux_idx][k]);
				if (val == TRUE) {
					someLitTrue = true;
				}
				else if (val == UNDEF){ 
					++numUndefs; 
					lastLitUndef = clauses[aux_idx][k]; 
				}
			}
			if (!someLitTrue and numUndefs == 0) {
				++numProp;
                int sumVC = numVars + numClauses;
                if (sumVC < numProp) {
                    for (uint i = 1; i != NumTimes.size(); ++i) {
                        NumTimes[i] /= 2;
                        if (0 >= NumTimes[i]) NumTimes[i] = 1;
                    }
                    numProp = 0;
                }
                for (uint j = 0; j != clauses[aux_idx].size(); ++j) {
                    int idx = clauses[aux_idx][j];
                    ++NumTimes[abs(idx)];
                }
				return true; // conflict! all lits false
			}
			else if (not someLitTrue and numUndefs == TRUE) {
				setLiteralToTrue(lastLitUndef);
			}
		}
	}
	return false;
}

void backtrack(){
	uint i = modelStack.size() -1;
	int lit = 0;
	while (modelStack[i] != 0){ // 0 is the DL mark
		lit = abs(modelStack[i]);
		model[lit] = UNDEF;
		modelStack.pop_back();
        --i;
		++NumTimes[abs(modelStack[i])];
	}
	// at this point, lit is the last decision
	modelStack.pop_back(); // remove the DL mark
	--decisionLevel;
	indexOfNextLitToPropagate = modelStack.size();
	setLiteralToTrue(-lit);  // reverse last decision
}



// Heuristic for finding the next decision literal:
int getNextDecisionLiteral(){
    uint max = 0;
    uint count = 0;
        
        for (uint i = 1; i < NumTimes.size(); ++i){ // not so stupid heuristic:
            if (model[i] == UNDEF) {
                if (count < NumTimes[i]) {
                    max = i;
                    count = NumTimes[i];
                }
            }
        }
        return max;
}

void checkmodel(){
	for (uint i = 0; i < numClauses; ++i){
		bool someTrue = false;
		for (uint j = 0; not someTrue and j < clauses[i].size(); ++j)
			someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
		if (not someTrue) {
			cout << "Error in model, clause is not satisfied:";
			for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
			cout << endl;
			exit(1);
		}
	}  
}

int main(){ 
	//float begin_time = clock();
	readClauses(); // reads numVars, numClauses and clauses
	model.resize(numVars+1,UNDEF);
	indexOfNextLitToPropagate = 0;  
	decisionLevel = 0;
	
	// Take care of initial unit clauses, if any
	for (uint i = 0; i < numClauses; ++i){
		if (clauses[i].size() == TRUE) {
			int lit = clauses[i][0];
			int val = currentValueInModel(lit);
			if (val == FALSE) {
				cout << "UNSATISFIABLE" << endl; 
				return 10;
			}
			else if (val == UNDEF) setLiteralToTrue(lit);
		}
    }
    
	// DPLL algorithm
	while (true) {
		while ( propagateGivesConflict() ) {
			if ( decisionLevel == 0) { 
				cout << "UNSATISFIABLE" << endl; 
				return 10; 
			}
			backtrack();
		}
		int decisionLit = getNextDecisionLiteral();
		if (decisionLit == 0) { 
			checkmodel(); 
			cout << "SATISFIABLE" << endl; 
			return 20; 
		}
		// start new decision level:
		modelStack.push_back(0);  // push mark indicating new DL
		++indexOfNextLitToPropagate;
		++decisionLevel;
		setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
	}
}  
