%{
#include<bits/stdc++.h>
using namespace std;
%}

%x attribute
%s endtag

ws			[ \t\r\n]*
letter		[A-za-z]
digit		[0-9]
attval      (\"[^<&"]*\")|("'"[^<&']*"'")
tag1		"html"|"head"|"title"|"body"|"h1"|"h2"|"h3"|"h4"|"h5"|"h6"|"p"|"!--...--"|"acronym"|"abbr"|"address"|"b"|"bdi"|"bdo"|"big"|"blockquote"|"center"|"cite"|"code"|"del"|"dfn"|"em"|"font"|"i"|"ins"|"kbd"|"mark"|"meter"|"pre"|"progress"|"q"|"rp"|"rt"|"ruby"|"s"|"samp"|"small"|"strike"|"strong"|"sub"|"sup"|"template"|"time"|"tt"|"u"|"var"|"form"|"textarea"|"button"|"select"|"optgroup"|"option"|"label"|"fieldset"|"legend"|"datalist"|"output"|"frame"|"frameset"|"noframes"|"iframe"|"map"|"canvas"|"figcaption"|"figure"|"picture"|"svg"|"audio"|"video"|"a"|"nav"|"ul"|"ol"|"li"|"dir"|"dl"|"dt"|"dd"|"menu"|"menuitem"|"table"|"caption"|"th"|"tr"|"td"|"thead"|"tbody"|"tfoot"|"colgroup"|"style"|"div"|"span"|"header"|"footer"|"main"|"section"|"article"|"aside"|"details"|"dialog"|"summary"|"data"|"head"|"basefont"|"script"|"noscript"|"applet"|"object"
tag2		"area"|"base"|"br"|"col"|"command"|"embed"|"hr"|"img"|"input"|"keygen"|"link"|"meta"|"param"|"source"|"track"|"wbr"
cdata		[^<&]*

%%
"<"{tag1}	{yylval=yytext[1];BEGIN(attribute);return START_TAG1;}
"<"{tag2}	{yylval=yytext[1];BEGIN(attribute);return START_TAG2;}
<attribute>	{
				{att}{ws}[=]		{yylval=;return ATT;}
				attval 			    {yylval=;return ATT_VAL;}
				{ws}				;
				(">")				{BEGIN(endtag);return *yytext;}
			}
<endtag> 	{
				"</"{tag1}">" {yytext=;return END_TAG1;}
			}
{cdata}     {yylval=;return DATA;}