Definitions.
D = [0-9]
L = [a-z_|A-Z_]
O = \+|\=|\-|\*|/|//|\^|&|\||~|>>|<<|\=\=|~\=|<|>|<\=|>\=|\.\.|#|\%
%R = and|break|do|else|elseif|end|false|for|function|got|if|in|local|nil|not|or|repeat|return|then|true|until|while 
P = \.|:|\,



Rules.
{L}+{D}*            :{token, analyze(TokenLine, TokenChars)}.
\n|\r|\t            :skip_token.
\s                  :{token,{espacio,TokenLine,TokenChars}}.
\s\s\s\s            :{token,{tab,TokenLine,TokenChars}}.
{D}+                :{token,{int,TokenLine,TokenChars}}.
{D}+\.{D}+          :{token, {realnum, TokenLine, TokenChars}}.
{R}+                :{token, analyze(TokenLine, TokenChars)}.
--.*                :{token, {comentario, TokenLine, TokenChars}}. 
[\(\)\{\}\[\]]      :{token, {delimitador, TokenLine, TokenChars}}.
["\'][^"\']*["\']  :{token, {string, TokenLine, TokenChars}}.
{O}                 :{token,{operator,TokenLine,TokenChars}}.
{P}                 :{token, {puntuacion, TokenLine, TokenChars}}.    



Erlang code.
analyze(TokenLine, TokenChars) ->
    IsKW = lists:member(TokenChars, ["and", "break", "do", "else", "elseif", "end", "false", "for", "function", "got", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"]),
    if

        IsKW -> {keyword, TokenLine, TokenChars};

        true -> {identifier, TokenLine, TokenChars}
    end.
