%option noyywrap
%option outfile="lex.yy.cpp"

%{
#define YY_NO_UNISTD_H

#include <stdio.h>
#include <io.h>
#include "Trans.hpp"

char* strdupDebug(const char* data){
#if _DEBUG
	printf("[ DEBUG LEXER  INFO ]: ");
	printf(data);
	printf("\n");
#endif
	return _strdup(data);
}


%}

%%

"IF"				     { yylval.str = strdupDebug(yytext); return IF;			  }  
"WHILE"				     { yylval.str = strdupDebug(yytext); return WHILE;		  }
"ELSE"				     { yylval.str = strdupDebug(yytext); return ELSE;		  }
"FOR"				     { yylval.str = strdupDebug(yytext); return FOR;          }
"TRUE "					 { yylval.str = strdupDebug(yytext); return TRUE;		  }
"FALSE "				 { yylval.str = strdupDebug(yytext); return FALSE;		  }
"float "				 { yylval.str = strdupDebug(yytext); return FLOAT;		  }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdupDebug(yytext); return IDENTIFYER;	  }
[0-9]+					 { yylval.str = strdupDebug(yytext); return NUM;		  } 
[0-9]+"."[0-9]*			 { yylval.str = strdupDebug(yytext); return POINT_NUM;    } 
"+"						 { yylval.str = strdupDebug(yytext); return PLUS;		  }
"-"						 { yylval.str = strdupDebug(yytext); return MINUS;		  }
"*"						 { yylval.str = strdupDebug(yytext); return MULT;		  }
"/"						 { yylval.str = strdupDebug(yytext); return DIV;		  }
"**"					 { yylval.str = strdupDebug(yytext); return EXP;		  }
"&&"					 { yylval.str = strdupDebug(yytext); return AND;		  }
"||"					 { yylval.str = strdupDebug(yytext); return OR;			  }
">"						 { yylval.str = strdupDebug(yytext); return MORE;		  }
"<"						 { yylval.str = strdupDebug(yytext); return LESS;		  }
">="					 { yylval.str = strdupDebug(yytext); return SOFT_MORE;	  }
"<="				   	 { yylval.str = strdupDebug(yytext); return SOFT_LESS;	  }
"="					 	 { yylval.str = strdupDebug(yytext); return ASSIGN_EQUAL; }
"!="					 { yylval.str = strdupDebug(yytext); return NOT_EQUAL;	  }
"!"						 { yylval.str = strdupDebug(yytext); return NOT;		  }
"("						 { yylval.str = strdupDebug(yytext); return OPEN_BRACKET; }
")"						 { yylval.str = strdupDebug(yytext); return CLOSE_BRACKET;}
"{"						 { yylval.str = strdupDebug(yytext); return OPEN_BRACE;	  }
"}"						 { yylval.str = strdupDebug(yytext); return CLOSE_BRACE;  }
","						 { yylval.str = strdupDebug(yytext); return COMMA;		  }
";"						 { yylval.str = strdupDebug(yytext); return SEMICOLON;	  }
[ \t\r\n]
[à-ÿÀ-ß?¹#~`':%$]		 { yylval.str = strdupDebug(yytext); return ERROR;		  }
<<EOF>>					 {									 return END_OF_FILE;  }
 
%%

#include <iostream>

YY_BUFFER_STATE buffer;
void ScanBegin(const char* c) {
	buffer = yy_scan_string(c);
}

void ScanEnd() {
	yy_delete_buffer(buffer);
}