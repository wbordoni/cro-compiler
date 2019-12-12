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

%left       TOK_PLUS        TOK_MINUS       TOK_MUL         TOK_DIV
%left       TOK_AND         TOK_OR          TOK_NOT
%right      TOK_LPAR        TOK_RPAR

%type <sVal>    code
%type <sVal>    addition
%type <sVal>    substraction
%type <sVal>    multiplication
%type <sVal>    division
%type <sVal>    affectation
%type <sVal>    variable
%type <sVal>    instruction
%type <sVal>    arithmetic_expr
%type <sVal>    execution
%type <sVal>    boolean_expr
%type <sVal>    expr

// terminal symbols
%token <sVal>   TOK_INT
%token <sVal>   TOK_FLOAT
%token <sVal>   TOK_ID
%token <sVal>   TOK_COMMENT
%token <sVal>   TOK_EQUAL
%token <sVal>   TOK_ENDL
%token <sVal>   TOK_PRINT
%token <sVal>   TOK_TRUE
%token <sVal>   TOK_FALSE

%%
code:       %empty {}
|           code instruction {
    printf("[BISON] instruction: %s\n", $2);
    }
|           code TOK_COMMENT {
    printf("[BISON] comment: %s\n", $2);
    }
;

variable:
    TOK_ID  {
    $$ = strdup($1);
    }
;

instruction:
    affectation {}
|   execution   {}
;

affectation:
            variable  TOK_EQUAL   expr  TOK_ENDL {
            $$ = strcat(strcat(strdup($1),strdup("=")),strdup($3));
            //printf("[BISON] affectation: %s\n", $2);
            }
;

execution:
            TOK_PRINT   expr   TOK_ENDL {
            //printf("[BISON] print: %s\n", $2);
            }
;

expr:
            arithmetic_expr {}
|           boolean_expr    {}
;


arithmetic_expr:
            addition        {}
|           substraction    {}
|           multiplication  {}
|           division        {}
|           TOK_INT     { $$ = strdup($1); }
|           TOK_FLOAT   { $$ = strdup($1); }
|           variable    { $$ = strdup($1); }
|           TOK_LPAR    arithmetic_expr  TOK_RPAR  {
    //printf("[BISON] sub-arithmetic_expr: (%s)\n", $2);
    $$ = strcat(strcat(strdup("("),strdup($2)),strdup(")"));
    }
;

boolean_expr:
            TOK_TRUE    { $$ = strdup("TRUE"); }
|           TOK_FALSE   { $$ = strdup("FALSE"); }
|           TOK_NOT boolean_expr   { $$ = strcat(strdup("NOT "),strdup($2)); }
|           boolean_expr    TOK_AND     boolean_expr {
            $$ = strcat(strcat(strdup($1),strdup(" AND ")),strdup($3));
            }
|           boolean_expr    TOK_OR      boolean_expr {
            $$ = strcat(strcat(strdup($1),strdup(" OR ")),strdup($3));
            }
|           TOK_LPAR    boolean_expr    TOK_RPAR {
            $$ = strcat(strcat(strdup("("),strdup($2)),strdup(")"));
            }
;



addition:
            arithmetic_expr  TOK_PLUS    arithmetic_expr  {
            $$ = strcat(strcat(strdup($1),strdup("+")),strdup($3));
            }
;
substraction:
            arithmetic_expr  TOK_MINUS    arithmetic_expr  {
            $$ = strcat(strcat(strdup($1),strdup("-")),strdup($3));
            }
;

multiplication:
            arithmetic_expr  TOK_MUL    arithmetic_expr  {
            $$ = strcat(strcat(strdup($1),strdup("*")),strdup($3));
            }
;
division:
            arithmetic_expr  TOK_DIV    arithmetic_expr  {
            $$ = strcat(strcat(strdup($1),strdup("/")),strdup($3));
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
    printf("[BISON] Parse ERROR: %s\n", s);
    exit(-1);
}
