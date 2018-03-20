%{
#include<bits/stdc++.h>
#include "y.tab.h"
using namespace std;
void CleanText(char* s);
int flag;
%}

%x attribute
%s endtag

ws			[ \t\r\n]*
letter		[A-za-z]
digit		[0-9]
attval      (\"([^\"]*)\")|("'"[^\']*"'")
tag1		"html"|"head"|"title"|"body"|"h1"|"h2"|"h3"|"h4"|"h5"|"h6"|"p"|"!--...--"|"acronym"|"abbr"|"address"|"b"|"bdi"|"bdo"|"big"|"blockquote"|"center"|"cite"|"code"|"del"|"dfn"|"em"|"font"|"i"|"ins"|"kbd"|"mark"|"meter"|"pre"|"progress"|"q"|"rp"|"rt"|"ruby"|"s"|"samp"|"small"|"strike"|"strong"|"sub"|"sup"|"template"|"time"|"tt"|"u"|"var"|"form"|"textarea"|"button"|"select"|"optgroup"|"option"|"label"|"fieldset"|"legend"|"datalist"|"output"|"frame"|"frameset"|"noframes"|"iframe"|"map"|"canvas"|"figcaption"|"figure"|"picture"|"svg"|"audio"|"video"|"a"|"nav"|"ul"|"ol"|"li"|"dir"|"dl"|"dt"|"dd"|"menu"|"menuitem"|"table"|"caption"|"th"|"tr"|"td"|"thead"|"tbody"|"tfoot"|"colgroup"|"style"|"div"|"span"|"header"|"footer"|"main"|"section"|"article"|"aside"|"details"|"dialog"|"summary"|"data"|"head"|"basefont"|"script"|"noscript"|"applet"|"object"
tag2		"area"|"base"|"br"|"col"|"command"|"embed"|"hr"|"img"|"input"|"keygen"|"link"|"meta"|"param"|"source"|"track"|"wbr"
AttList1    "abbr"|"accept-charset"|"accept"|"accesskey"|"action"|"align"|"alink"|"alt"|"archive"|"axis"|"background"|"bgcolor"|"border"
AttList2    "cellpadding"|"cellspacing"|"char"|"charoff"|"charset"|"checked"|"cite"|"class"|"classid"|"clear"|"code"|"codebase"|"codetype"
AttList3    "color"|"cols"|"colspan"|"compact"|"content"|"coords"|"data"|"datetime"|"declare"|"defer"|"dir"|"disabled"|"enctype"|"face"|"for"
AttList4    "frame"|"frameborder"|"headers"|"height"|"href"|"hreflang"|"hspace"|"http-equiv"|"id"|"ismap"|"label"|"lang"|"language"|"link"
AttList5    "longdesc"|"marginheight"|"marginwidth"|"maxlength"|"media"|"method"|"multiple"|"name"|"nohref"|"noresize"|"noshade"|"nowrap"
AttList6    "object"|"onblur"|"onchange"|"onclick"|"ondblclick"|"onfocus"|"onkeydown"|"onkeypress"|"onkeyup"|"onload"|"onmousedown"|"onmousemove"
AttList7    "onmouseout"|"onmouseover"|"onmouseup"|"onreset"|"onselect"|"onsubmit"|"onunload"|"profile"|"prompt"|"readonly"|"rel"|"rev"|"rows"
AttList8    "rowspan"|"rules"|"scheme"|"scope"|"scrolling"|"selected"|"shape"|"size"|"span"|"src"|"standby"|"start"|"style"|"summary"|"tabindex"
AttList9    "target"|"text"|"title"|"type"|"usemap"|"valign"|"value"|"valuetype"|"version"|"vlink"|"vspace"|"width"
StarAtt     ({letter}|{digit}|[-])+
cdata		[^<]*
Comment     "<!--"[^-]*[-]{2,}([^->][^-]*[-]{2,})*">"

%%

"<!DOCTYPE"([^<]*)">"  	;
{ws}					;
"<"(?i:{tag1})	{
				printf("start %s\n",yytext);
				yylval.data=strdup(yytext+1);
				BEGIN(attribute);
				flag=1;
				return START_TAG1;
				}
"<"(?i:{tag2})	{	
				printf("startself %s\n",yytext);
				yylval.data=strdup(yytext+1);
				BEGIN(attribute);
				flag=0;
				return START_TAG2;
				}
<attribute>{
	{StarAtt}{ws}[=]		{	printf("attribute %s\n",yytext);
								yylval.data=strdup(yytext);
								return ATT;
							}
	{attval} 			    {	printf("attval %s\n",yytext);
								yylval.data=strdup(yytext);
								return ATT_VAL;
							}
	{ws}					{	printf("space\n");	}
	(">")					{	printf("startend %s\n",yytext);
								BEGIN(endtag);
								yylval.data=strdup(yytext);
								if(flag==0)
									return END_TAG2;
								else
									return *yytext;
							}
	("/>")					{
								printf("endtagself %s\n",yytext);
								BEGIN(endtag);
								yylval.data=strdup(yytext);
								return END_TAG2;
							}
}
<endtag>{
				"</"(?i:{tag1})">" 	{	
									printf("endtag %s\n",yytext);
									yylval.data=strdup(yytext);
									return END_TAG1;
							  		}
				"/>"		  	{
								printf("endtagself %s\n",yytext);
								yylval.data=strdup(yytext);
								return END_TAG2;
							  	}
}
{cdata}     {
				//printf("text %s\n",yytext);
				yylval.data=strdup(yytext);
				return DATA;
			}

{Comment}   {
               // printf("Comment %s\n",yytext);
            }


.         	;
%%

int yywrap()
{
	return 1;
}