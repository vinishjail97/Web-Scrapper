# Web-Scrapper
Scrapping Web data using HTML Parser made from lex and yacc. 

lex.l -Contains lex Specifications of tags and identifiers 
yacc.y -Contains Grammar Rules for HTML 
test.html - Test Input File 
output.txt -Contains Parse Tree obtained after parsing
taginfo.txt - Information about the input tag 

Commands for Compiling 
lex lex.l
yacc -d yacc.y
g++ lex.yy.c y.tab.c -o parser  

Usage: ./parser test.html 
