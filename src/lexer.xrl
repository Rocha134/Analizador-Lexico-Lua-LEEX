Definitions.
D = [0-9]
L = [a-z_|A-Z_]
O = \+|\=|\-|\*|/|//|\^|&|\||~|>>|<<|\=\=|~\=|<|>|<\=|>\=|\.\.|#|\%
%R = and|break|do|else|elseif|end|false|for|function|got|if|in|local|nil|not|or|repeat|return|then|true|until|while

Rules.
{L}+{D}*            :{token, analyze(TokenLine, TokenChars)}.
\s|\n|\r            :skip_token.
{D}+                :{token,{int,TokenLine,TokenChars}}.
{D}+\.{D}+          :{token, {realnum, TokenLine, TokenChars}}.
{R}+                :{token, analyze(TokenLine, TokenChars)}.
--.+                :{token, {comentario, TokenLine, TokenChars}}.
[\(\)\{\}\[\]]      :{token, {delimitador, TokenLine, TokenChars}}.
["\'].+["\']        :{token, {string, TokenLine, TokenChars}}.
{O}                 :{token,{operator,TokenLine,TokenChars}}.


Erlang code.

analyze(TokenLine, TokenChars) ->
    IsKW = lists:member(TokenChars, ["and", "break", "do", "else", "elseif", "end", "false", "for", "function", "got", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"]),
    if

        IsKW -> {keyword, TokenLine, TokenChars};

        true -> {identifier, TokenLine, TokenChars}
    end.
