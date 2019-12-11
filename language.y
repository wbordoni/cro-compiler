%{
#include "stdio.h"
#include <string.h>
#include "stdlib.h"

extern int yylex();
//extern int yyparse();

void yyerror(const char *s);

%}

// TOKEN type returned by flex
%union {
    int iVal;
    float fVal;
    char *sVal;
}

%left       TOK_PLUS        TOK_MINUS
%left       TOK_MUL         TOK_DIV
%right      TOK_LEFTPAR     TOK_RIGHTPAR

%type <sVal>    code
%type <sVal>    command
%type <sVal>    expression
%type <sVal>    addition
%type <sVal>    substraction
%type <sVal>    multiplication
%type <sVal>    division


// terminal symbols
%token <sVal>   TOK_INT
%token <sVal>   TOK_FLOAT
%token <sVal>   TOK_STRING
%token <sVal>   TOK_COMMENT

%%
code:       %empty {}
|           code command {
    printf("[BISON] command found: %s\n", $2);

    }
|           code TOK_COMMENT {
    printf("[BISON] TOK_COMMENT found: %s\n", $2);
    free($2);
    }
;

command:
            addition        {}
|           substraction    {}
|           multiplication  {}
|           division        {}
;

addition:
            expression  TOK_PLUS    expression  {
            $$ = strcat(strcat(strdup($1),strdup("+")),strdup($3));
            }
;
substraction:
            expression  TOK_MINUS    expression  {
            $$ = strcat(strcat(strdup($1),strdup("-")),strdup($3));
            }
;

multiplication:
            expression  TOK_MUL    expression  {
            $$ = strcat(strcat(strdup($1),strdup("*")),strdup($3));
            }
;
division:
            expression  TOK_DIV    expression  {
            $$ = strcat(strcat(strdup($1),strdup("/")),strdup($3));
            }
;

expression:
    TOK_INT     {
    // printf("[BISON] TOK_INT found: %d\n", $1);
    $$ = strdup($1);
    }

|   TOK_FLOAT   {
    // printf("[BISON] TOK_FLOAT found: %f\n", $1);
    $$ = strdup($1);
    }
    
|   TOK_STRING  {
    // printf("[BISON] TOK_STRING found: %s\n", $1);
    $$ = strdup($1);
    }
;

%%

int main(int argc, char **argv)
{
    printf("> Starting Bison parser...\n");
    yyparse();
    printf("> Bison done.\n");
    return 0;
}


void yyerror(const char *s)
{
    printf("[BISON] Parse ERROR : %s\n", s);
    exit(-1);
}
