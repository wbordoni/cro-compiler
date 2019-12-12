%{

#include "stdio.h"
#include "stdlib.h"
#include "math.h"
#include "string.h"
#include "language.tab.h"

int debug(char* t, char* str, int l);

%}

%option yylineno
%option noyywrap

DIGIT           [0-9]
ID              [a-z][a-z0-9]*

%%
{DIGIT}+                {
    //debug("Integer", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_INT;
}

{DIGIT}+"."{DIGIT}*     {
    //debug("Float", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_FLOAT;
}

{ID}                    {
    //debug("Identifier", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_ID;
}

\n                      {}
[ \t]+                  {}

    
"PRINT"                 {
    //debug("Print", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_PRINT;
}

#.*                     {
    //debug("Comment", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_COMMENT;
}


"+"                     {
    //debug("Operator", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_PLUS;
}

"-"                     {
    //debug("Operator", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_MINUS;
}

"*"                     {
    //debug("Operator", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_MUL;
}

"="                     {
    //debug("Operator", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_EQUAL;
}

"/"                     {
    //debug("Operator", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_DIV;
}

"("                     {
    //debug("Left parenthesis", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_LPAR;
}

")"                     {
    //debug("Right Parenthesis", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_RPAR;
}

";"                     {
    //debug("Semicolon", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_ENDL;
}

"AND"                     {
    //debug("And", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_AND;
}

"OR"                     {
    //debug("Or", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_OR;
}

"NOT"                     {
    //debug("Not", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_NOT;
}

"TRUE"                     {
    //debug("True", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_TRUE;
}

"FALSE"                     {
    //debug("False", yytext, yylineno);
    yylval.sVal = yytext;
    return TOK_FALSE;
}

.   debug("Undefined token", yytext, yylineno);

%%

int debug(char* t, char* str, int l)
{
    printf("[FLEX] %d: <%s> %s\n", l, t, str);
}



/*

int main(void)
{
    printf("> Starting Flex analyser...\n");
    yylex();
    printf("> Done.\n");
    return 0;
}
*/
