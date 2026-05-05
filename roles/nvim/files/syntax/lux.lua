if vim.b.current_syntax then
  return
end

vim.cmd([[
  syn match luxStmt /^\s*/
              \ nextgroup=luxMeta,luxSend,luxMatch,luxExitPattern,luxComment
  syn region luxStmt start=/^\z(\s*\)"""/ end=/\z1"""$/ keepend
              \ contains=luxMetaMultiline,luxSendBlock,luxMatchBlock,luxExitBlock

  syn region luxMeta start=/\[/ skip=/\\\n/ end=/\($\|\]\)/ keepend contained
  syn region luxMetaMultiline start=/"""\[/ end=/"""/ keepend contained
  syn match luxMetaStart /\[/ contained containedin=luxMeta
              \ nextgroup=luxKeyword,luxDecl,luxLoopKeyword,luxBadMeta
  syn match luxMetaStart /"""\[/ contained containedin=luxMetaMultiline
              \ nextgroup=luxKeyword,luxDecl,luxLoopKeyword,luxBadMeta
  syn match luxMetaEnd /\]/ contained containedin=luxMeta
  syn match luxMetaEnd /\]\s*\n\s*"""/ contained containedin=luxMetaMultiline
  syn region luxArgs start=// end=/\]/ contained
              \ contains=luxVariable,luxSpecSym,luxMetaEnd
  syn region luxArgsWithStrings start=// end=/\]/ contained
             \ contains=luxVariable,luxSpecSym,luxMultiString,luxString,luxMetaEnd

  syn region luxString start=/"/ skip=/\\"/ end=/"/ contained extend
  syn region luxMultiString matchgroup=luxString start=/^\z(\s*\)"""/
                          \ matchgroup=luxString end=/^\z1"""/ contained extend

  syn match luxNumArg /[0-9]\+/ contained nextgroup=luxMetaEnd skipwhite
  syn match luxVarArg /\(\$\)\@1<!\$[a-zA-Z0-9_]\+/ contained
              \ nextgroup=luxMetaEnd skipwhite

  syn keyword luxKeyword config include contained nextgroup=luxArgs skipwhite
  syn keyword luxKeyword shell contained nextgroup=luxArgs skipwhite
  syn keyword luxKeyword newshell contained nextgroup=luxArgs skipwhite
  syn keyword luxKeyword pattern_mode contained nextgroup=luxArgs skipwhite
  syn keyword luxKeyword timeout contained
              \ nextgroup=luxNumArg,luxVarArg,luxMetaEnd skipwhite
  syn keyword luxKeyword sleep contained nextgroup=luxNumArg,luxVarArg skipwhite
  syn keyword luxKeyword endshell contained
              \ nextgroup=luxNumArg,luxMetaEnd skipwhite
  syn keyword luxKeyword cleanup contained nextgroup=luxMetaEnd,luxBadMeta
  syn keyword luxKeyword invoke contained nextgroup=luxInvokeName skipwhite
  syn keyword luxDecl macro contained nextgroup=luxMacroName skipwhite
  syn keyword luxDecl my local global contained nextgroup=luxVarName skipwhite
  syn keyword luxDecl endmacro contained nextgroup=luxMetaEnd,luxBadMeta
  syn keyword luxLoopKeyword loop contained nextgroup=luxLoopVarDecl skipwhite
  syn keyword luxLoopKeyword endloop contained nextgroup=luxMetaEnd,luxBadMeta

  syn match luxBadMeta /[^] ]\+\( \|\]\)\@1=/ contained nextgroup=luxMetaEnd

  syn match luxLoopVarDecl /[a-zA-Z0-9_]\+/ contained nextgroup=luxArgs
  syn match luxMacroName /[a-zA-Z0-9_-]\+/ contained nextgroup=luxArgs
  syn match luxInvokeName /[a-zA-Z0-9_-]\+/ contained nextgroup=luxArgsWithStrings
  syn match luxVarName /[a-zA-Z0-9_]\+/ contained skipwhite
                                      \ nextgroup=equalSign,luxBadMeta

  syn match equalSign /=/ contained nextgroup=luxArgs
  syn match equalSign /=\n/ contained nextgroup=luxArgsWithStrings extend

  syn match luxInfoStart /\("""\)\?\[\(progress\|doc[1-9]\? \)/ contained
              \ containedin=luxMetaStart contains=luxInfo
  syn region luxInfo start=/\[progress/ end=/\]/
                       \ contained contains=luxVariable,luxSpecSym
  syn region luxInfo start=/\[doc[1-9]\? / end=/\]/
                       \ contained contains=luxSpecSym
  syn match luxInfoEnd /\]\s*\n\s*"""/ contained containedin=luxInfo
  syn region luxInfo start=/\[doc\]/ end=/\[enddoc\]/
                   \ contained containedin=luxMeta extend
                   \ contains=luxSpecSym

  syn keyword luxTodo TODO FIXME XXX NOTE contained
  syn match luxComment /^\s*#.*$/ contains=luxTodo

  syn match luxSend /!/ contained nextgroup=luxVarLine
  syn match luxSend /\~/ contained nextgroup=luxVarLine
  syn region luxSendBlock matchgroup=luxSend start=/"""\(!\|\~\)/
                        \ matchgroup=luxSend end=/"""/ keepend
                        \ contained contains=luxVarLine
  syn match luxMatch /?/ contained nextgroup=luxPatternLine
  syn match luxMatch /??/ contained nextgroup=luxVarLine
  syn match luxMatch /???/ contained nextgroup=luxVerbatimLine
  syn match luxMatch /@/ contained nextgroup=luxPatternLine
  syn match luxMatch /?+/ contained nextgroup=luxPatternLine
  syn region luxMatchBlock matchgroup=luxMatch start=/"""\(??\|?+\|?\)/
                         \ matchgroup=luxMatch end=/"""/ keepend
                         \ contained contains=luxPatternLine
  syn region luxMatchBlock matchgroup=luxMatch start=/"""???/
                         \ matchgroup=luxMatch end=/"""/ keepend
                         \ contained contains=luxVerbatimLine
  syn match luxExitPattern /-/ contained nextgroup=luxPatternLine
  syn match luxExitPattern /+/ contained nextgroup=luxPatternLine
  syn region luxExitBlock matchgroup=luxExitPattern start=/"""[-+]/
                        \ matchgroup=luxExitPattern end=/"""/ keepend
                        \ contained contains=luxPatternLine

  syn region luxVarLine start=/./ skip=/\\\n/ end=/$/ contained
              \ contains=luxVariable,luxSpecSym
  syn region luxPatternLine start=/./ skip=/\\\n/ end=/$/ contained
              \ contains=luxVariable,luxSpecSym,luxPatternSym
  syn region luxVerbatimLine start=/./ skip=/\\\n/ end=/$/ contained

  syn match luxPatternSym /\(\\\)\@1<![\^\$.|()?*+{]/ contained
  syn region luxPatternSym start=/\(\\\)\@1<!\[/ skip=/\\]/ end=/\]/
              \ oneline contained
  syn match luxPatternSym /\\[aefnrt]/ contained
  syn match luxPatternSym /\\[dDhHsSvVwW]/ contained
  syn match luxPatternSym /\\\(c[a-z]\|0[0-7]+\|x[0-9a-f]\+\)/ contained
  syn match luxPatternSym /\\\(o{[0-7]+}\|x{[0-9a-f]\+}\)/ contained
  syn match luxPatternSym /(?[isxmU-]\+)/ contained
  syn region luxPatternSym start=/(?<\?[=!]/ end=/)/
              \ contained contains=luxSkipParenthesis

  syn region luxSkipParenthesis start=/\(\\\)\@1<!(/ skip=/\\)/ end=/)/
              \ transparent contained

  syn match luxVariable /\(\$\)\@1<!\$[a-zA-Z0-9_]\+/ contained
  syn region luxVariable start="\(\$\)\@1<!\${" end="}" oneline contained

  syn match luxSpecVar /\${\?_\(TAB\|BS\|LF\|CR\|ESC\|DEL\|CTRL_[A-Z]\|ASCII_\([0-9]\|[0-9][0-9]\|1[0-1][0-9]\|12[0-7]\)\)_}\?/
              \ contained containedin=luxVariable
  syn match luxSpecVar /\${\?\([0-9]\+\|LUX_SHELLNAME\|LUX_TIMEOUT\|LUX_START_REASON\|LUX_EXTRA_LOGS\)}\?/
              \ contained containedin=luxVariable

  syn match luxSpecSym /\\\(n\|t\|\\\)/ contained

  syn sync minlines=100
]])

vim.api.nvim_set_hl(0, "luxLoopKeyword", { link = "Repeat", default = true })
vim.api.nvim_set_hl(0, "luxMacro",       { link = "Macro", default = true })
vim.api.nvim_set_hl(0, "luxDecl",        { link = "Define", default = true })
vim.api.nvim_set_hl(0, "luxInfoStart",   { link = "Label", default = true })
vim.api.nvim_set_hl(0, "luxInfo",        { link = "Label", default = true })
vim.api.nvim_set_hl(0, "luxInfoEnd",     { link = "Label", default = true })
vim.api.nvim_set_hl(0, "luxComment",     { link = "Comment", default = true })
vim.api.nvim_set_hl(0, "luxKeyword",     { link = "Statement", default = true })
vim.api.nvim_set_hl(0, "luxTodo",        { link = "Todo", default = true })
vim.api.nvim_set_hl(0, "luxSend",        { link = "Operator", default = true })
vim.api.nvim_set_hl(0, "luxMatch",       { link = "Conditional", default = true })
vim.api.nvim_set_hl(0, "luxExitPattern", { link = "Exception", default = true })
vim.api.nvim_set_hl(0, "luxVariable",    { link = "Macro", default = true })
vim.api.nvim_set_hl(0, "luxVarArg",      { link = "Macro", default = true })
vim.api.nvim_set_hl(0, "luxSpecVar",     { link = "Special", default = true })
vim.api.nvim_set_hl(0, "luxSpecSym",     { link = "Special", default = true })
vim.api.nvim_set_hl(0, "luxPatternSym",  { link = "Special", default = true })
vim.api.nvim_set_hl(0, "luxVarName",     { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "luxLoopVarDecl", { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "luxMacroName",   { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "luxInvokeName",  { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "luxBadMeta",     { link = "Error", default = true })
vim.api.nvim_set_hl(0, "luxMetaStart",   { link = "Structure", default = true })
vim.api.nvim_set_hl(0, "luxMetaEnd",     { link = "Structure", default = true })
vim.api.nvim_set_hl(0, "luxString",      { link = "String", default = true })
vim.api.nvim_set_hl(0, "luxNumArg",      { link = "Number", default = true })
vim.api.nvim_set_hl(0, "equalSign",      { link = "Operator", default = true })

vim.b.current_syntax = "lux"
