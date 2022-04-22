Definitions.
D = [0-9]
L = [a-z|A-Z]



Rules.
{L}+                :{token,{identifier,TokenLine,TokenChars}}.
{D}+                :{token,{int,TokenLine,TokenChars}}.
{D}+\.{D}+          :{token, {realnum, TokenLine, TokenChars}}.

Erlang code.

