if vim.b.current_syntax then
  return
end

vim.cmd([[
  " Top-level block keywords
  syn keyword alliumTopKeyword given value entity config rule invariant actor surface
              \ nextgroup=alliumTypeName skipwhite

  " Block sub-keywords used inside rule/surface blocks
  syn keyword alliumSubKeyword when requires ensures facing context exposes provides
  syn keyword alliumSubKeyword let contained containedin=alliumBlock

  " Control flow
  syn keyword alliumControl for in

  " Built-in constants and query keywords
  syn keyword alliumBuiltin where not exists now null true false count

  " Built-in primitive types
  syn keyword alliumType String Integer Boolean Duration Timestamp

  " Generic types: List<T>, Map<K,V>
  syn match alliumGenericType /\<\(List\|Map\)<[^>]*>/

  " State transition methods: .created, .updated, .deleted
  syn match alliumTransition /\.\(created\|updated\|deleted\)\>/

  " Duration literals: 30.minutes, 2.seconds, 55.hours, etc.
  syn match alliumDuration /\<[0-9]\+\.\(seconds\|minutes\|hours\|days\)\>/

  " Plain numbers
  syn match alliumNumber /\<[0-9]\+\>/

  " Optional marker on types: Type?
  syn match alliumOptional /?/

  " Enum variant separator
  syn match alliumEnumSep /|/

  " Operators and comparison
  syn match alliumOperator /[!<>]=\?/
  syn match alliumOperator /=\([=>]\)\@!/
  syn match alliumOperator /+/

  " Annotation markers @guidance and @guarantee [Name]
  syn match alliumAnnotation /@guidance\|@guarantee\s\+[A-Za-z][A-Za-z0-9]*/

  " PascalCase identifiers (entity/type/rule names)
  syn match alliumTypeName /\<[A-Z][A-Za-z0-9]*\>/

  " Allium version header: -- allium: N
  syn match alliumVersion /^--\s*allium:\s*[0-9]\+\s*$/

  " Comments (must come last so @guidance inside comment blocks are not re-highlighted)
  syn match alliumTodo /\<\(TODO\|FIXME\|XXX\|NOTE\)\>/ contained
  syn match alliumComment /--.*$/ contains=alliumTodo

  " Strings
  syn region alliumString start=/"/ skip=/\\"/ end=/"/

  " Block delimiters
  syn region alliumBlock start=/{/ end=/}/ transparent fold

  syn sync minlines=50
]])

vim.api.nvim_set_hl(0, "alliumTopKeyword",  { link = "Structure",   default = true })
vim.api.nvim_set_hl(0, "alliumSubKeyword",  { link = "Statement",   default = true })
vim.api.nvim_set_hl(0, "alliumControl",     { link = "Repeat",      default = true })
vim.api.nvim_set_hl(0, "alliumBuiltin",     { link = "Keyword",     default = true })
vim.api.nvim_set_hl(0, "alliumType",        { link = "Type",        default = true })
vim.api.nvim_set_hl(0, "alliumGenericType", { link = "Type",        default = true })
vim.api.nvim_set_hl(0, "alliumTransition",  { link = "Special",     default = true })
vim.api.nvim_set_hl(0, "alliumDuration",    { link = "Number",      default = true })
vim.api.nvim_set_hl(0, "alliumNumber",      { link = "Number",      default = true })
vim.api.nvim_set_hl(0, "alliumOptional",    { link = "Special",     default = true })
vim.api.nvim_set_hl(0, "alliumEnumSep",     { link = "Operator",    default = true })
vim.api.nvim_set_hl(0, "alliumOperator",    { link = "Operator",    default = true })
vim.api.nvim_set_hl(0, "alliumAnnotation",  { link = "PreProc",     default = true })
vim.api.nvim_set_hl(0, "alliumTypeName",    { link = "Identifier",  default = true })
vim.api.nvim_set_hl(0, "alliumVersion",     { link = "Special",     default = true })
vim.api.nvim_set_hl(0, "alliumTodo",        { link = "Todo",        default = true })
vim.api.nvim_set_hl(0, "alliumComment",     { link = "Comment",     default = true })
vim.api.nvim_set_hl(0, "alliumString",      { link = "String",      default = true })

vim.b.current_syntax = "allium"
