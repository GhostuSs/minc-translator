%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
	#include <iostream>
	#include <stdio.h>

	#define YYERROR_VERBOSE 1	

	void yyerror (const char *error);
	extern int yylex();
	extern int yyparse();

	extern void ScanBegin(const char* line);
	extern void ScanEnd();

	bool isOk = false;

	void printDebug(std::string data){
	#if _DEBUG
		if (data != "") {
			std::cout << "[ DEBUG PARSER INFO ]: " << data << std::endl;
		}
	#endif
	}
%}

%union
{
	char* str;
}

%type <str> total prg stml stmt idl expl bexp exp

%token <str> IF WHILE ELSE FOR TRUE FALSE FLOAT IDENTIFYER NUM POINT_NUM PLUS 
MINUS MULT DIV EXP AND OR MORE LESS SOFT_MORE SOFT_LESS ASSIGN_EQUAL NOT_EQUAL 
NOT OPEN_BRACKET CLOSE_BRACKET OPEN_BRACE CLOSE_BRACE COMMA SEMICOLON ERROR
%token END_OF_FILE

%%


total: prg { 
	printDebug("total <- stml"); 
	isOk = true; 
	YYACCEPT; 
}; 

prg: stml END_OF_FILE                                               {  printDebug("prg <- stml END_OF_FILE");								};

stml:     
stmt																{  printDebug("stml < stmt");								}
| stmt SEMICOLON													{  printDebug("stml < stmt SEMICOLON");					}
| stml stmt															{  printDebug("stml < stml stmt");							}
| stml stmt SEMICOLON												{  printDebug("stml < stml stmt SEMICOLON");				}

stmt:	  
FLOAT idl															{  printDebug("stmt < FLOAT idl");														 }
| IDENTIFYER ASSIGN_EQUAL exp										{  printDebug("stmt < IDENTIFYER ASSIGN_EQUAL exp");									 }
| IF bexp stmt														{  printDebug("stmt < IF bexp stmt");													 }
| IF bexp stmt ELSE stmt											{  printDebug("stmt < IF bexp stmt ELSE stmt");										 }
| WHILE bexp stmt												    {  printDebug("stmt < WHILE bexp stmt");												 }
| FOR OPEN_BRACKET stmt COMMA bexp COMMA stmt CLOSE_BRACKET stmt    {  printDebug("stmt < FOR OPEN_BRACKET stmt COMMA bexp COMMA stmt CLOSE_BRACKET stmt"); }
| IDENTIFYER OPEN_BRACKET expl CLOSE_BRACKET					    {  printDebug("stmt < IDENTIFYER OPEN_BRACKET expl CLOSE_BRACKET");					 }
| OPEN_BRACE stml CLOSE_BRACE									    {  printDebug("stmt < OPEN_BRACE stml CLOSE_BRACE");									 }

idl:	  
IDENTIFYER					   									    {  printDebug("idl < IDENTIFYER");						}
| idl COMMA IDENTIFYER		  									    {  printDebug("idl < idl COMMA IDENTIFYER");				}

expl:     
exp								     							    {  printDebug("expl < exp");									}
| exp COMMA expl				     							    {  printDebug("expl < exp COMMA expl");					}
|																	{  printDebug("expl < EMPTY");}
 
bexp:    
exp									 							    {  printDebug("bexp < exp");								}
| NOT bexp							 							    {  printDebug("bexp < NOT bexp");							}
| bexp AND bexp						 							    {  printDebug("bexp < bexp AND bexp");						}
| bexp OR bexp													    {  printDebug("bexp < bexp OR bexp");						}
| bexp ASSIGN_EQUAL bexp		     							    {  printDebug("bexp < bexp ASSIGN_EQUAL bexp");			}
| exp LESS exp													    {  printDebug("bexp < exp LESS exp");						}
| exp MORE exp						 							    {  printDebug("bexp < exp MORE exp");						}
| exp NOT_EQUAL exp												    {  printDebug("bexp < exp NOT_EQUAL exp");				    }
| exp SOFT_LESS exp												    {  printDebug("bexp < exp SOFT_LESS exp");					}
| exp SOFT_MORE exp												    {  printDebug("bexp < exp SOFT_MORE exp");					}
| TRUE															    {  printDebug("bexp < TRUE");								}
| FALSE															    {  printDebug("bexp < FALSE");								}

exp:	  
exp EXP exp							 							    {  printDebug("exp < exp EXP exp");						}
| MINUS exp														    {  printDebug("exp < MINUS exp");							}
| exp MULT exp						 							    {  printDebug("exp < exp MULT exp");						}
| exp DIV exp						 							    {  printDebug("exp < exp DIV exp");						}
| exp PLUS exp													    {  printDebug("exp < exp PLUS exp");						}
| exp MINUS exp													    {  printDebug("exp < exp MINUS exp");						}
| OPEN_BRACKET bexp CLOSE_BRACKET   							    {  printDebug("exp < OPEN_BRACKET bexp CLOSE_BRACKET");   }
| NUM															    {  printDebug("exp < NUM");								}
| POINT_NUM														    {  printDebug("exp < POINT_NUM");							}
| IDENTIFYER													    {  printDebug("exp < IDENTIFYER");						}

%%

#include <iostream>
#include <fstream>
#include <string>

void main() {
	while (true) {
		std::string path;
		std::cout << "File path > ";
		std::cin >> path;
		std::ifstream inPipe(path.c_str());
		if (!inPipe.is_open()) {
			std::cout << "Coldnt open file" << std::endl;
		}else{
			std::string line;
			std::string data;
			
			while (getline(inPipe, line)){
				data += line;
			}
			std::cout << "=========================Parse started===========================" << std::endl;
			isOk = false;
			ScanBegin(data.c_str());
			yyparse();
			ScanEnd();
			if (isOk){
				std::cout << "\n=======================SYNTAX IS VALID===========================\n" << std::endl;
			}
			std::cout << "=================================================================" << std::endl;
			inPipe.close();
		}
		system("pause");
		system("cls");
	}
}

void yyerror (const char *error) 
{	
	std::cout << "==============================ERROR==============================" << std::endl;
	std::cout << error << std::endl;
	std::cout << "=================================================================" << std::endl;
	isOk = false;
}
