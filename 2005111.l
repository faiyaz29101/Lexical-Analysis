%option noyywrap

%x STRING_STATE
%x MULTI_COMMENT_STATE
%x SINGLE_COMMENT_STATE

%{
#include<iostream>
#include <fstream>
#include "SymbolTable.h"

using namespace std;

int line_count = 1;
int error_count = 0;
int warning_count = 0;
ofstream logprint;
ofstream tokenprint;
string string_log;
string string_token;
int lc = 0;
int check_string =0;
string com;
int temp_line = 0;



int bucket_size = 10;
SymbolTable symbolTable(bucket_size);


string UpperCase(string s){
	for(int i=0;i<s.length();i++){
		if(s[i]>='a' && s[i]<='z'){
			s[i] = s[i] - 32;
		}
	}
	return s;
}
char processChar(const char* s){
    if( strlen(s) == 3 ) return s[1];
    if( s[2] == 'n' ) return '\n';
    if( s[2] == 't' ) return '\t';
   if( s[2] == '\\' ) return '\\';
    if( s[2] == 'a' ) return '\a';
    if( s[2] == 'f' ) return '\f';
    if( s[2] == 'r' ) return '\r';
    if( s[2] == 'b' ) return '\b';
    if( s[2] == 'v' ) return '\v';
   if( s[2] == '0' ) return '\0';
    if( s[2] == '\"' ) return '\"';
}



%}

KEYWORD if|else|while|for|do|break|char|int|float|double|return|void|switch|case|default|continue
LETTER [a-zA-Z]
DIGIT [0-9]
WHITESPACE [ \t]
EMPTY_CHAR_ERROR ''
INTEGER ([1-9]+)([0-9])*|0
FLOAT([0-9]*)\.([0-9]+)
EXPONENT1 ([0-9]+([E][\+\-]?[0-9]+))
EXPONENT2 ([0-9]*(\.[0-9]+)([E][\+\-]?[0-9]+)?)
IDENTIFIERS [A-Za-z_][A-Za-z0-9_]*
CHARACTER_LITERALS1 \'([a-zA-Z])\'
STRING /"([a-zA-Z0-9 ]*)
CHARACTER_LITERALS2 \'(\\[ntrabv0\"])\'


%%


{KEYWORD} {
		tokenprint << "<" << UpperCase(yytext) << ", " << yytext << ">"<<endl;
		logprint << "Line# " << line_count << ": Token <"<< UpperCase(yytext)<<"> Lexeme "<<yytext<<" found" << endl;
	}
{INTEGER} {
	tokenprint << "<" << "CONST_INT" << ", " << yytext << ">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<CONST_INT>"<<" Lexeme "<<yytext<<" found"<<endl;
}
{FLOAT} {
	tokenprint << "<" << "CONST_FLOAT" << ", " << yytext << ">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
}
{EXPONENT1} {
	tokenprint << "<" << "CONST_FLOAT" << ", " << yytext << ">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
}
{EXPONENT2} {
	tokenprint << "<" << "CONST_FLOAT" << ", " << yytext << ">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found"<<endl;
}
{CHARACTER_LITERALS1} {
	tokenprint << "<" << "CONST_CHAR" << ", " << processChar(yytext) << ">"<<endl;
   // cout<<yytext <<'    ' << processChar1(yytext)<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<CONST_CHAR>"<<" Lexeme "<<processChar(yytext)<<" found"<<endl;
}
{CHARACTER_LITERALS2} {
	tokenprint << "<" << "CONST_CHAR" << ", " << processChar(yytext) << ">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<CONST_CHAR>"<<" Lexeme "<<processChar(yytext)<<" found"<<endl;
}
{WHITESPACE} {

}
"+"|"-" {
    tokenprint<<"<ADDOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<ADDOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"*"|"/"|"%"  {
    tokenprint<<"<MULOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<MULOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"++"|"--"  {
    tokenprint<<"<INCOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<INCOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"<"|"<="|">"|">="|"=="|"!="  {
    tokenprint<<"<RELOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<RELOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"="  {
    tokenprint<<"<ASSIGNOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<ASSIGNOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"&&"|"||"  {
    tokenprint<<"<BITOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<BITOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"&"|"|"|"^"|"<<"|">>" {
	tokenprint<<"<BITOP, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<BITOP>"<<" Lexeme "<<yytext<<" found"<<endl;
}

"!"  {
    tokenprint<<"<NOT, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<NOT>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"("  {
    tokenprint<<"<LPAREN, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<LPAREN>"<<" Lexeme "<<yytext<<" found"<<endl;
}
")"  {
    tokenprint<<"<RPAREN, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<RPAREN>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"{"  {
    tokenprint<<"<LCURL, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<LCURL>"<<" Lexeme "<<yytext<<" found"<<endl;
	//logprint<<symbolTable.printAllScope();
    symbolTable.enterScope();
}
"}"  {
    tokenprint<<"<RCURL, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<RCURL>"<<" Lexeme "<<yytext<<" found"<<endl;
	symbolTable.exitScope();
  //  logprint<<symbolTable.printAllScope();
}
"["  {
    tokenprint<<"<LSQUARE, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<LSQUARE>"<<" Lexeme "<<yytext<<" found"<<endl;
}
"]"  {
    tokenprint<<"<RSQUARE, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<RSQUARE>"<<" Lexeme "<<yytext<<" found"<<endl;
}
","  {
    tokenprint<<"<COMMA, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<COMMA>"<<" Lexeme "<<yytext<<" found"<<endl;
}
";"  {
    tokenprint<<"<SEMICOLON, "<<yytext<<">"<<endl;
    logprint<<"Line# "<< line_count <<": Token " <<"<SEMICOLON>"<<" Lexeme "<<yytext<<" found"<<endl;
}

{IDENTIFIERS} {
		tokenprint << "<" << "ID" << ", " << yytext << ">"<<endl;
		logprint << "Line# " << line_count << ": Token <"<< "ID"<<"> Lexeme "<<yytext<<" found" << endl;
        if(!symbolTable.findfromcurrent(yytext)){
            symbolTable.add(yytext, "ID");
		    logprint<<symbolTable.printAllScope();
        }else{
            logprint<<"\t"<<yytext<< " already exists in the current ScopeTable"<<endl;
        }

	}

\/\/ {
    com = yytext;
    temp_line = line_count;
    BEGIN SINGLE_COMMENT_STATE;
}
<SINGLE_COMMENT_STATE>.* {
    com+=yytext;
    line_count++;
}
<SINGLE_COMMENT_STATE>.*\\\n {
    com+=yytext;
    line_count++;
}
<SINGLE_COMMENT_STATE>.*\n {
    com+=yytext;
    com.erase(com.length()-1);
//    tokenprint<<"<SINGLE LINE COMMENT, "<<com<<">"<<endl;
    logprint<<"Line# "<< temp_line <<": Token " <<"<SINGLE LINE COMMENT>"<<" Lexeme "<<com<<" found"<<endl;
    line_count++;
    BEGIN INITIAL;
}



"\n" {
		line_count++;
}
\/\* {

    com = "/*";
    BEGIN MULTI_COMMENT_STATE;
    temp_line = line_count;
}
<MULTI_COMMENT_STATE>.(\*)*\n {
    com+=yytext;
    line_count++;
}
<MULTI_COMMENT_STATE>.(\*)* {
    com+=yytext;
}
<MULTI_COMMENT_STATE>.*\*\/ {
    com+=yytext;
    logprint<<"Line# "<< temp_line <<": Token " <<"<MULTI LINE COMMENT>"<<" Lexeme "<<com<<" found"<<endl;
    BEGIN INITIAL;
}
<MULTI_COMMENT_STATE><<EOF>> {
    error_count++;
    logprint<<"Error at line# "<<line_count<<": UNFINISHED_COMMENT "<<com<<endl;
    BEGIN INITIAL;
    //line_count++;
}


<STRING_STATE>\\t  {
     string_log+="\\t";
     string_token+="\t";
    // cout<<"HEJERFJ" <<string_token<<endl;
     line_count++;
}
<STRING_STATE>[a-zA-Z0-9 ]* {
    string_log+=yytext;
  //  cout<<yytext<<endl;
    string_token+=yytext;
}
<STRING_STATE>\\\n  {
    string_log+="\\";
    string_log+="\n\t";
    string_token+='\t';
    line_count++;
    check_string=1;
   // cout<<"hewh"<<endl;
}

<STRING_STATE>\\r  {
    string_log+="\r";
    string_token+="\r";
    line_count++;
}

<STRING_STATE>[\r]?\n {
    error_count++;
    logprint<<"Error at line# "<<line_count<<": UNFINISHED_STRING "<<string_log<<endl;
    line_count+=lc+1;
    BEGIN INITIAL;
}
<STRING_STATE><<EOF>> {
    error_count++;
    logprint<<"Error at line# "<<line_count<<": UNFINISHED_STRING "<<string_log<<endl;
    line_count++;
    BEGIN INITIAL;
}
<STRING_STATE>\\\\ {
    string_log+="\\\\";
    string_token+="\\";
}
<STRING_STATE>\\a {
    string_log+="\\a";
    string_token+="\a";
}

<STRING_STATE>\\b {
    string_log+="\\b";
    string_token+="\b";
}
<STRING_STATE>\\v {
    string_log+="\\v";
    string_token+="\v";
}
<STRING_STATE>\\0 {
    string_log+="\\0";
    string_token+="\0";
}


\" {
   lc = 0;
   string_log = "\"";
   string_token = "\"";
   temp_line = line_count;
   BEGIN STRING_STATE;
}
<STRING_STATE>\"  {
    string_log+="\"";
    string_token+="\"";
    if(check_string==0){
    tokenprint<<"<SINGLE LINE STRING, "<<string_token<<">"<<endl;
    logprint<<"Line# "<< temp_line <<": Token " <<"<SINGLE LINE STRING>"<<" Lexeme "<<string_log<<" found"<<endl;
    line_count+=lc-1;
    }else{
    tokenprint<<"<MULTI LINE STRING, "<<string_token<<">"<<endl;
    logprint<<"Line# "<< temp_line <<": Token " <<"<MULTI LINE STRING>"<<" Lexeme "<<string_log<<" found"<<endl;
    check_string=0;
    line_count+=lc;
    }
    BEGIN INITIAL;
}


[0-9]*\.[0-9]*?[\.0-9]* {
    logprint <<"Error at line# "<<line_count<<": TOO_MANY_DECIMAL_POINTS "<<yytext<<endl;
    error_count++;
}
[0-9]*\.?[0-9]*[E][/+\-]?[\.0-9]* {
    logprint << "Error at line# "<<line_count<<": ILLFORMED_NUMBER "<<yytext<<endl;
    error_count++;
}
[0-9]+[a-zA-Z _]+ {
    logprint << "Error at line# "<<line_count<<": INVALID_ID_SUFFIX_NUM_PREFIX "<<yytext<<endl;
    error_count++;
}
\'[a-zA-Z]+[a-zA-z0-9 ]+\' {
    logprint << "Error at line# "<<line_count<<": MULTICHAR_CONST_CHAR "<<yytext<<endl;
    error_count++;
}
\'[a-zA-Z]+";"?\n {
    string s = yytext;
    s.erase(s.length()-1);
    logprint << "Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<s<<endl;
    error_count++;
    line_count++;
}
\'";"?\n {
    string s = yytext;
    s.erase(s.length()-1);
    logprint << "Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<s<<endl;
    error_count++;
    line_count++;
}
\'\\\' {
    logprint << "Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<yytext<<endl;
    error_count++;
}
\'\' {
    logprint << "Error at line# "<<line_count<<": EMPTY_CONST_CHAR "<<yytext<<endl;
    error_count++;
}




. {
    logprint << "Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<yytext<<endl;
    error_count++;
}


%%
int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}

	tokenprint.open("2005111_token.txt");
	logprint.open("2005111_log.txt");

	yyin= fin;
	yylex();
	fclose(yyin);

	logprint<<symbolTable.printAllScope();

	logprint<<"Total lines: "<<line_count<<endl;
	logprint<<"Total errors: "<<error_count<<endl;
    logprint<<"Total warnings: "<<warning_count<<endl;

	tokenprint.close();
	logprint.close();


	return 0;
}