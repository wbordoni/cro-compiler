%{

#include "stdio.h"
#include "stdlib.h"

int debug(char* t, char* str, int l);

%}

%option yylineno

number          [[:digit:]]+(\.[[:digit:]]+)*
variable        [[:alpha:]][[:alnum:]]*

%%
{number}        debug("number", yytext, yylineno);
{variable}      debug("variable", yytext, yylineno);

\n              {}
" "|"\t"        {}

"+"             debug("addition", yytext, yylineno);
"-"             debug("substraction", yytext, yylineno);
"/"             debug("division", yytext, yylineno);
"*"             debug("multiplication", yytext, yylineno);
"("             debug("open parenthesis", yytext, yylineno);
")"             debug("close parenthesis", yytext, yylineno);

%%

int debug(char* t, char* str, int l)
{
    printf("Line %d: <%s> found: %s\n", l, t, str);
}

int yywrap()
{
    return 1;
}

int main(void)
{
    printf("> Starting CRO-compiler...\n");
    yylex();
    printf("> Done.\n");

}


