%{
#include <bits/stdc++.h>
using namespace std;
extern int yylex();
extern int yyparse();
extern FILE *yyin;
ofstream fout;
void yyerror(const char* s);
struct node
{
	string tag,data;
	vector<node*> child;
	vector<string> att,att_val;
	int flag;
};
stack<node*> s;
node* makeNewEmptyNode()
{
	node* a=new node;
	a->flag=0;
	return a;
}
node* makeNewDataNode(char* s)
{
	node* a=new node;
	string temp(s);
	a->data=temp;
	a->flag=1;
	return a;
}
node* makeNewInterNode()
{
	node* a=new node;
	a->tag="inter";
	a->flag=2;
	return a;
}
%}

%union {
	char* data;
	int id;
}
%start S
%token<data> START_TAG1 START_TAG2 ATT ATT_VAL END_TAG1 END_TAG2  DATA
%type<data> S A S1


%%

S 	: START_TAG1 A '>' S1 END_TAG1 {	
										printf("1 %s %s\n",$1,$5);
										node* c1=s.top();
										//cout<<c1->flag<<endl;
										s.pop();
										node* c2=s.top();
										s.pop();
										c2->tag=$1;
										c2->child.push_back(c1);
										s.push(c2);
										
									}
	| START_TAG2 A END_TAG2 	{ 	
									printf("2 %s\n",$1);
									s.top()->tag=string($1);

								}
	| DATA {	printf("3 %s\n",$1);s.push(makeNewDataNode($1)); }
	;
A 	: A ATT ATT_VAL { 
						printf("4 %s %s\n",$2,$3);
						string t1($2);
					 	string t2($3);
					 	s.top()->att.push_back(t1);
					 	s.top()->att_val.push_back(t2);
					 	$$=$1;
					} 
	| /*emtpy*/ {	printf("5\n");s.push(makeNewEmptyNode()); }
	;
S1 	: S1 S { }  {	printf("6\n");
					node* c1=s.top();
					s.pop();
					node* c2=s.top();
					s.pop();
					node* c=makeNewInterNode();
					c->child.push_back(c2);
					c->child.push_back(c1);
					s.push(c);
					$$=$1;
				}
	| /*empty*/	{	printf("7\n");
					s.push(makeNewInterNode()); }
	;
%%

void yyerror(const char* s)
{
	printf("Error %s\n",s);
}
void PrintTree(node* t,int val)
{
	for(int i=0;i<val;i++)fout<<" ";
	
	if(t->flag==1)
	{
		fout<<t->data<<endl;
		return;
	}
	if(t->flag==0)
	{

		fout<<t->tag<<" ";
		for(int i=0;i<t->att.size();i++)
			fout<<t->att[i]<<" ";
		for(int i=0;i<t->att_val.size();i++)
			fout<<t->att_val[i]<<" ";
	}
	fout<<endl;
	for(int i=0;i<t->child.size();i++)
		PrintTree(t->child[i],val+1);
} 
void PrintSubTree(node* t,string s,ofstream &out)
{
	if(t->flag==1)
	{
		out<<t->data<<endl;
	}
	for(int i=0;i<t->child.size();i++)
		PrintSubTree(t->child[i],s,out);
}
void FindTaginfo(node* t,string s,ofstream &out)
{
	if(t->flag==0 && t->tag==s) //tag has been found 
	{
		PrintSubTree(t,s,out);
	}
	for(int i=0;i<t->child.size();i++)
		FindTaginfo(t->child[i],s,out);
}
int main(int argc,char **argv)
{
	if(argc<2)
	{
		printf("Enter input file \n");
		return 0;
	}
	FILE* fd=fopen(argv[1], "r");
	yyin=fd;
	do {
		yyparse();
	} while (!feof(yyin));
  	fclose(yyin);
  	fout.open("output.txt");
  	PrintTree(s.top(),0);

  	cout<<"Enter tag info u want\n";
  	string input;
  	cin>>input;

  	ofstream out;
  	out.open("taginfo.txt");
  	FindTaginfo(s.top(),input,out);
  	return 0;
}






