
// Struct that holds all input parameters from a file
struct ParameterFile {

	// List expected parameters and type here
	double L1;
	int N1;
        double Let;
	double diameter;
	double R2;
	double pamp;
	double freq;
        double iposn;
	double R1;
	double amp;

	// Debugging function to print the values of parameters
	void print(){
		//cout <<"param1 = " <<param1 <<endl;
		//cout <<"param2 = " <<param2 <<endl;
		//cout <<"param3 = " <<param3 <<endl;
		//cout <<"param4 = " <<param4 <<endl;
	}

	// Set parameter values given input file name
	void set(string & param_file){

		ifstream fsin(param_file);
		string tmp_line;

		while (getline(fsin, tmp_line)){
			istringstream ssin(tmp_line.substr(tmp_line.find("=") + 1 ));
			if (tmp_line.find("L1") != -1){ ssin >> L1; }
			else if (tmp_line.find("N1") != -1){ ssin >> N1; }
			else if (tmp_line.find("Let") != -1){ ssin >> Let;}
			else if (tmp_line.find("diameter") != -1){ ssin >> diameter; }
			else if (tmp_line.find("R2") != -1){ ssin >> R2; }
			else if (tmp_line.find("pamp") != -1){ ssin >> pamp; }
			else if (tmp_line.find("freq") != -1){ ssin >> freq; }
			else if (tmp_line.find("iposn") != -1){ ssin >> iposn; }
			else if (tmp_line.find("R1") != -1){ R1 = R2+diameter; }
			else if (tmp_line.find("amp") != -1){ amp = pamp*diameter/2.0 ; }
			else {
				cout <<"Parameter '" <<tmp_line <<"' not found!" <<endl;
				exit(EXIT_FAILURE);
			}
		}
	}

	// Declare constructor and descructor
	//ParameterFile();
	//~ParameterFile();
};
