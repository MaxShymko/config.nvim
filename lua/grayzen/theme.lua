local theme = {}

function theme.highlights(colors)
    local function load_syntax()
        -- Syntax highlight groups

        local syntax = {
            -- int, long, char, etc.
            Type = { fg = colors.dark_blue },
            -- static, register, volatile, etc.
            StorageClass = { fg = colors.dark_blue },
            -- struct, union, enum, etc.
            Structure = { fg = colors.dark_blue },
            -- any constant
            Constant = { fg = colors.dark_blue },
            -- any character constant: 'c', '\n'
            Character = { fg = colors.green },
            -- a number constant: 5
            Number = { fg = colors.blue },
            -- a boolean constant: TRUE, false
            Boolean = { fg = colors.dark_blue },
            -- a floating point constant: 2.3e10
            Float = { fg = colors.blue },
            -- any statement
            statement = { fg = colors.fg },
            -- case, default, etc.
            label = { fg = colors.dark_blue },
            -- sizeof", "+", "*", etc.
            operator = { fg = colors.fg },
            -- try, catch, throw
            exception = { fg = colors.dark_blue },
            -- generic preprocessor
            preproc = { fg = colors.dark_blue },
            -- preprocessor #include
            Include = { fg = colors.dark_blue },
            -- preprocessor #define
            Define = { fg = colors.dark_blue },
            -- same as Define
            Macro = { fg = colors.dark_blue },
            -- A typedef
            Typedef = { fg = colors.dark_blue },
            -- preprocessor #if, #else, #endif, etc.
            PreCondit = { fg = colors.dark_blue },
            -- any special symbol
            Special = { fg = colors.dark_blue },
            -- special character in a constant
            SpecialChar = { fg = colors.dark_blue },
            -- you can use CTRL-] on this
            Tag = { fg = colors.dark_blue },
            -- character that needs attention like , or .
            Delimiter = { fg = colors.fg },
            -- special things inside a comment
            SpecialComment = { fg = colors.gray },
            -- debugging statements
            Debug = { fg = colors.yellow },
            -- text that stands out, HTML links
            Underlined = { fg = colors.none, style = "underline" },
            -- left blank, hidden
            Ignore = { fg = colors.fg, bg = colors.bg, style = "bold" },
            -- any erroneous construct
            Error = { fg = colors.error, bg = colors.none, style = "bold,underline" },
            -- anything that needs extra attention; mostly the keywords TODO FIXME and XXX
            Todo = { fg = colors.blue, bg = colors.none, style = "bold,italic" },
            Comment = { fg = colors.gray }, -- normal comments
            -- normal if, then, else, endif, switch, etc.
            Conditional = { fg = colors.dark_blue },
            -- normal for, do, while, etc.
            Keyword = { fg = colors.dark_blue },
            -- normal any other keyword
            Repeat = { fg = colors.dark_blue },
            -- normal function names
            Function = { fg = colors.fg, style = "italic" },
            -- any variable name
            Identifier = { fg = colors.fg },
            -- any string
            String = { fg = colors.green },

            htmlLink = { fg = colors.green, style = "underline" },
            htmlArg = { fg = colors.dark_blue },
            htmlTag = { fg = colors.dark_blue },
            htmlEndTag = { fg = colors.dark_blue },
            htmlTagN = { fg = colors.dark_blue },
            htmlTagName = { fg = colors.dark_blue },
            htmlSpecialTagName = { fg = colors.dark_blue },
            htmlH1 = { fg = colors.fg },
            htmlH2 = { fg = colors.fg },
            htmlH3 = { fg = colors.fg },
            htmlH4 = { fg = colors.fg },
            htmlH5 = { fg = colors.fg },

            cssAttributeSelector = { fg = colors.dark_blue },
            cssSelectorOp = { fg = colors.dark_blue },
            cssTagName = { fg = colors.dark_blue },

            markdownBlockquote = { fg = colors.gray },
            markdownBold = { fg = colors.fg, style = "bold" },
            markdownCode = { fg = colors.green },
            markdownCodeBlock = { fg = colors.green },
            markdownCodeDelimiter = { fg = colors.gray },
            markdownH1 = { fg = colors.fg, style = "bold" },
            markdownH2 = { fg = colors.fg, style = "bold" },
            markdownH3 = { fg = colors.fg, style = "bold" },
            markdownH4 = { fg = colors.fg },
            markdownH5 = { fg = colors.fg },
            markdownH6 = { fg = colors.fg },
            markdownH1Delimiter = { fg = colors.fg },
            markdownH2Delimiter = { fg = colors.fg },
            markdownH3Delimiter = { fg = colors.fg },
            markdownH4Delimiter = { fg = colors.fg },
            markdownH5Delimiter = { fg = colors.fg },
            markdownH6Delimiter = { fg = colors.fg },
            markdownId = { fg = colors.fg },
            markdownIdDeclaration = { fg = colors.fg },
            markdownIdDelimiter = { fg = colors.fg },
            markdownLinkDelimiter = { fg = colors.fg },
            markdownItalic = { fg = colors.fg, style = "italic" },
            markdownLinkText = { fg = colors.fg },
            markdownListMarker = { fg = colors.dark_blue },
            markdownOrderedListMarker = { fg = colors.dark_blue },
            markdownRule = { fg = colors.fg },
            markdownUrl = { fg = colors.link, style = "underline" },
        }

        return syntax
    end

    local function load_editor()
        -- Editor highlight groups

        local editor = {
            -- normal text and background color for floating windows
            NormalFloat = { fg = colors.fg, bg = colors.active },
            -- floating window border
            FloatBorder = { fg = colors.fg, bg = colors.active },
            -- used for the columns set with 'colorcolumn'
            ColorColumn = { fg = colors.none, bg = colors.float },
            -- placeholder characters substituted for concealed text (see 'conceallevel')
            Conceal = { bg = colors.bg },
            -- the character under the cursor
            Cursor = { fg = colors.fg, bg = colors.none, style = "reverse" },
            -- like Cursor, but used when in IME mode
            CursorIM = { fg = colors.fg, bg = colors.none, style = "reverse" },
            -- directory names (and other special names in listings)
            Directory = { fg = colors.fg, bg = colors.none },
            -- diff mode: Added line
            DiffAdd = { fg = colors.none, bg = colors.diff_add_bg },
            -- diff mode: Changed line
            DiffChange = { fg = colors.none, bg = colors.diff_change_bg },
            -- diff mode: Deleted line
            DiffDelete = { fg = colors.none, bg = colors.diff_remove_bg },
            -- diff mode: Changed text within a changed line
            DiffText = { fg = colors.none, bg = colors.diff_text_bg },
            -- error messages
            ErrorMsg = { fg = colors.error },
            -- line used for closed folds
            Folded = { fg = colors.blue, bg = colors.none, style = "italic" },
            -- 'foldcolumn'
            FoldColumn = { fg = colors.blue },
            -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
            IncSearch = { fg = colors.fg, bg = colors.search, style = "bold" },
            -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
            LineNr = { fg = colors.gray },
            -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
            CursorLineNr = { fg = colors.fg },
            -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
            MatchParen = { fg = colors.yellow, bg = colors.none, style = "bold" },
            -- 'showmode' message (e.g., "-- INSERT -- ")
            ModeMsg = { fg = colors.gray, style = "bold" },
            -- |more-prompt|
            MoreMsg = { fg = colors.gray, style = "bold" },
            -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist
            -- in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
            -- See also |hl-EndOfBuffer|.
            NonText = { fg = colors.gray },
            -- normal item |hl-Pmenu|
            Pmenu = { fg = colors.fg, bg = colors.float },
            -- selected item |hl-PmenuSel|
            PmenuSel = { bg = colors.highlight },
            -- scrollbar |hl-PmenuSbar|
            PmenuSbar = { bg = colors.float },
            -- thumb of the scrollbar  |hl-PmenuThumb|
            PmenuThumb = { bg = colors.gray },
            -- |hit-enter| prompt and yes/no questions
            Question = { fg = colors.fg },
            -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
            QuickFixLine = { bg = colors.float, style = "bold" },
            -- Line numbers for quickfix lists
            qfLineNr = { fg = colors.purple },
            -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
            Search = { fg = colors.fg, bg = colors.search },
            -- Unprintable characters: text displayed differently from what it really is.
            -- But not 'listchars' whitespace. |hl-Whitespace|
            SpecialKey = { fg = colors.dark_blue },
            -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
            SpellBad = { fg = colors.none, bg = colors.none, style = "italic,undercurl", sp = colors.green },
            -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
            SpellCap = { fg = colors.none, bg = colors.none, style = "italic,undercurl", sp = colors.yellow },
            -- Word that is recognized by the spellchecker as one that is used in another region.
            -- |spell| Combined with the highlighting used otherwise.
            SpellLocal = { fg = colors.none, bg = colors.none, style = "italic,undercurl", sp = colors.cyan },
            -- Word that is recognized by the spellchecker as one that is hardly ever used.
            -- |spell| Combined with the highlighting used otherwise.
            SpellRare = { fg = colors.none, bg = colors.none, style = "italic,undercurl", sp = colors.purple },
            -- status line of current window
            StatusLine = { fg = colors.fg, bg = colors.active },
            -- status lines of not-current windows Note: if this is equal to "StatusLine"
            -- Vim will use "^^^" in the status line of the current window.
            StatusLineNC = { fg = colors.gray, bg = colors.active },
            -- status line of current terminal window
            StatusLineTerm = { fg = colors.fg, bg = colors.active },
            -- status lines of not-current terminal windows Note: if this is equal to "StatusLine"
            -- Vim will use "^^^" in the status line of the current window.
            StatusLineTermNC = { fg = colors.gray, bg = colors.active },
            -- tab pages line, where there are no labels
            TabLineFill = { fg = colors.gray, bg = colors.active },
            -- tab pages line, active tab page label
            TablineSel = { fg = colors.cyan, bg = colors.bg },
            Tabline = { fg = colors.gray, bg = colors.active },
            -- titles for output from ":set all", ":autocmd" etc.
            Title = { fg = colors.cyan, bg = colors.none, style = "bold" },
            -- Visual mode selection
            Visual = { fg = colors.none, bg = colors.highlight },
            -- Visual mode selection when vim is "Not Owning the Selection".
            VisualNOS = { fg = colors.none, bg = colors.highlight },
            -- warning messages
            WarningMsg = { fg = colors.warn },
            -- "nbsp", "space", "tab" and "trail" in 'listchars'
            Whitespace = { fg = colors.new_light_gray },
            -- current match in 'wildmenu' completion
            WildMenu = { fg = colors.fg, bg = colors.none, style = "bold" },
            -- window bar of current window
            WinBar = { fg = colors.fg, bg = colors.bg },
            -- window bar of not-current windows
            WinBarNC = { fg = colors.gray, bg = colors.bg },
            -- Screen-column at the cursor, when 'cursorcolumn' is set.
            CursorColumn = { fg = colors.none, bg = colors.active },
            -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
            CursorLine = { fg = colors.none, bg = colors.active },
            -- Normal mode message in the cmdline
            NormalMode = { fg = colors.cyan, bg = colors.none, style = "reverse" },
            -- Insert mode message in the cmdline
            InsertMode = { fg = colors.new_light_gray, bg = colors.none, style = "reverse" },
            -- Replace mode message in the cmdline
            ReplacelMode = { fg = colors.light_red, bg = colors.none, style = "reverse" },
            -- Visual mode message in the cmdline
            VisualMode = { fg = colors.info, bg = colors.none, style = "reverse" },
            -- Command mode message in the cmdline
            CommandMode = { fg = colors.yellow, bg = colors.none, style = "reverse" },
            Warnings = { fg = colors.warn },

            healthError = { fg = colors.error },
            healthSuccess = { fg = colors.green },
            healthWarning = { fg = colors.warn },

            -- Dashboard
            -- DashboardShortCut = { fg = colors.cyan },
            -- DashboardHeader = { fg = colors.dark_blue },
            -- DashboardCenter = { fg = colors.purple },
            -- DashboardFooter = { fg = colors.green, style = "italic" },

            -- normal text and background color
            Normal = { fg = colors.fg, bg = colors.bg },
            NormalNC = { bg = colors.bg },
            SignColumn = { fg = colors.fg, bg = colors.none },

            -- the column separating vertically split windows
            VertSplit = { fg = colors.new_light_gray },

            EndOfBuffer = { fg = colors.gray },
        }

        return editor
    end

    local function load_treesitter()
        -- TreeSitter highlight groups

        local treesitter = {
            -- Annotations that can be attached to the code to denote some kind of meta information. e.g. C++/Dart attributes.
            ["@attribute"] = { fg = colors.purple },
            -- Boolean literals: `True` and `False` in Python.
            ["@boolean"] = { fg = colors.dark_blue },
            -- Character literals: `'a'` in C.
            ["@character"] = { fg = colors.green },
            -- Line comments and block comments.
            ["@comment"] = { fg = colors.gray },
            -- Keywords related to conditionals: `if`, `when`, `cond`, etc.
            ["@conditional"] = { fg = colors.dark_blue },
            -- Constants identifiers. These might not be semantically constant. E.g. uppercase variables in Python.
            ["@constant"] = { fg = colors.cyan },
            -- Built-in constant values: `nil` in Lua.
            ["@constant.builtin"] = { fg = colors.dark_blue },
            -- Constants defined by macros: `NULL` in C.
            ["@constant.macro"] = { fg = colors.dark_blue },
            -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
            ["@constructor"] = { fg = colors.dark_blue },
            -- Syntax/parser errors. This might highlight large sections of code while the user is typing
            -- still incomplete code, use a sensible highlight.
            ["@error"] = { fg = colors.error },
            -- Exception related keywords: `try`, `except`, `finally` in Python.
            ["@exception"] = { fg = colors.dark_blue },
            -- Object and struct fields.
            ["@field"] = { fg = colors.purple },
            -- Floating-point number literals.
            ["@float"] = { fg = colors.blue },
            -- Function calls and definitions.
            ["@function"] = { fg = colors.fg, style = "italic" },
            -- Built-in functions: `print` in Lua.
            ["@function.builtin"] = { fg = colors.fg, style = "italic" },
            -- Macro defined functions (calls and definitions): each `macro_rules` in Rust.
            ["@function.macro"] = { fg = colors.dark_blue },
            -- File or module inclusion keywords: `#include` in C, `use` or `extern crate` in Rust.
            ["@include"] = { fg = colors.dark_blue },
            -- Keywords that don't fit into other categories.
            ["@keyword"] = { fg = colors.dark_blue },
            -- Keywords used to define a function: `function` in Lua, `def` and `lambda` in Python.
            ["@keyword.function"] = { fg = colors.dark_blue },
            -- Unary and binary operators that are English words: `and`, `or` in Python; `sizeof` in C.
            ["@keyword.operator"] = { fg = colors.dark_blue },
            -- Keywords like `return` and `yield`.
            ["@keyword.return"] = { fg = colors.dark_blue },
            -- GOTO labels: `label:` in C, and `::label::` in Lua.
            ["@label"] = { fg = colors.purple },
            -- Method calls and definitions.
            ["@method"] = { fg = colors.fg, style = "italic" },
            -- Identifiers referring to modules and namespaces.
            ["@namespace"] = { fg = colors.fg },
            -- Numeric literals that don't fit into other categories.
            ["@number"] = { fg = colors.blue },
            -- Binary or unary operators: `+`, and also `->` and `*` in C.
            ["@operator"] = { fg = colors.fg },
            -- Parameters of a function.
            ["@parameter"] = { fg = colors.fg },
            -- References to parameters of a function.
            ["@parameter.reference"] = { fg = colors.fg },
            -- Same as `@field`.
            ["@property"] = { fg = colors.purple },
            -- Punctuation delimiters: Periods, commas, semicolons, etc.
            ["@punctuation.delimiter"] = { fg = colors.fg },
            -- Brackets, braces, parentheses, etc.
            ["@punctuation.bracket"] = { fg = colors.fg },
            -- Special punctuation that doesn't fit into the previous categories.
            ["@punctuation.special"] = { fg = colors.fg },
            -- Keywords related to loops: `for`, `while`, etc.
            ["@repeat"] = { fg = colors.dark_blue },
            -- String literals.
            ["@string"] = { fg = colors.green },
            -- Regular expression literals.
            ["@string.regex"] = { fg = colors.blue },
            -- Escape characters within a string: `\n`, `\t`, etc.
            ["@string.escape"] = { fg = colors.dark_blue },
            -- Identifiers referring to symbols or atoms.
            ["@symbol"] = { fg = colors.fg },
            -- Tags like HTML tag names.
            ["@tag"] = { fg = colors.dark_blue },
            -- HTML tag attributes.
            ["@tag.attribute"] = { fg = colors.dark_blue },
            -- Tag delimiters like `<` `>` `/`.
            ["@tag.delimiter"] = { fg = colors.fg },
            -- Non-structured text. Like text in a markup language.
            ["@text"] = { fg = colors.fg },
            -- Text to be represented in bold.
            ["@text.strong"] = { fg = colors.fg, style = "bold" },
            -- Text to be represented with emphasis.
            ["@text.emphasis"] = { fg = colors.fg, style = "italic" },
            -- Text to be represented with an underline.
            ["@text.underline"] = { style = "underline" },
            -- Text that is part of a title.
            ["@text.title"] = { fg = colors.fg, style = "bold" },
            -- Literal or verbatim text.
            ["@text.literal"] = { fg = colors.green },
            -- added text (for diff files)
            ["@text.diff.add"] = { fg = colors.diff_add },
            -- deleted text (for diff files)
            ["@text.diff.delete"] = { fg = colors.diff_remove },
            -- URIs like hyperlinks or email addresses.
            ["@text.uri"] = { fg = colors.blue, style = "underline" },
            -- Math environments like LaTeX's `$ ... $`
            ["@text.math"] = { fg = colors.fg },
            -- Footnotes, text references, citations, etc.
            ["@text.reference"] = { fg = colors.purple },
            -- Text environments of markup languages.
            ["@text.environment"] = { fg = colors.fg },
            -- Text/string indicating the type of text environment. Like the name of a `\begin` block in LaTeX.
            ["@text.environment.name"] = { fg = colors.fg },
            -- Text TODOS
            ["@text.todo"] = { fg = colors.blue },
            -- Text representation of an informational note.
            ["@note"] = { fg = colors.info, style = "bold" },
            -- Text representation of a warning note.
            ["@warning"] = { fg = colors.warn, style = "bold" },
            -- Text representation of a danger note.
            ["@danger"] = { fg = colors.error, style = "bold" },
            -- Type (and class) definitions and annotations.
            ["@type"] = { fg = colors.fg },
            -- Built-in types: `i32` in Rust.
            ["@type.builtin"] = { fg = colors.dark_blue },
            -- Variable names that don't fit into other categories.
            ["@variable"] = { fg = colors.cyan },
            -- Variable names defined by the language: `this` or `self` in Javascript.
            ["@variable.builtin"] = { fg = colors.dark_blue },
        }

        return treesitter
    end

    local function load_lsp()
        -- Lsp highlight groups

        local lsp = {
            -- used for "Error" diagnostic virtual text
            LspDiagnosticsDefaultError = { fg = colors.error },
            -- used for "Error" diagnostic signs in sign column
            LspDiagnosticsSignError = { fg = colors.error },
            -- used for "Error" diagnostic messages in the diagnostics float
            LspDiagnosticsFloatingError = { fg = colors.error },
            -- Virtual text "Error"
            LspDiagnosticsVirtualTextError = { fg = colors.error },
            -- used to underline "Error" diagnostics.
            LspDiagnosticsUnderlineError = { sp = colors.error },
            -- used for "Warning" diagnostic signs in sign column
            LspDiagnosticsDefaultWarning = { fg = colors.warn },
            -- used for "Warning" diagnostic signs in sign column
            LspDiagnosticsSignWarning = { fg = colors.warn },
            -- used for "Warning" diagnostic messages in the diagnostics float
            LspDiagnosticsFloatingWarning = { fg = colors.warn },
            -- Virtual text "Warning"
            LspDiagnosticsVirtualTextWarning = { fg = colors.warn },
            -- used to underline "Warning" diagnostics.
            LspDiagnosticsUnderlineWarning = { sp = colors.warn },
            -- used for "Information" diagnostic virtual text
            LspDiagnosticsDefaultInformation = { fg = colors.info },
            -- used for "Information" diagnostic signs in sign column
            LspDiagnosticsSignInformation = { fg = colors.info },
            -- used for "Information" diagnostic messages in the diagnostics float
            LspDiagnosticsFloatingInformation = { fg = colors.info },
            -- Virtual text "Information"
            LspDiagnosticsVirtualTextInformation = { fg = colors.info },
            -- used to underline "Information" diagnostics.
            LspDiagnosticsUnderlineInformation = { sp = colors.info },
            -- used for "Hint" diagnostic virtual text
            LspDiagnosticsDefaultHint = { fg = colors.hint },
            -- used for "Hint" diagnostic signs in sign column
            LspDiagnosticsSignHint = { fg = colors.hint },
            -- used for "Hint" diagnostic messages in the diagnostics float
            LspDiagnosticsFloatingHint = { fg = colors.hint },
            -- Virtual text "Hint"
            LspDiagnosticsVirtualTextHint = { fg = colors.hint },
            -- used to underline "Hint" diagnostics.
            LspDiagnosticsUnderlineHint = { sp = colors.hint },
            -- used for highlighting "text" references
            LspReferenceText = { style = "underline", sp = colors.yellow },
            -- used for highlighting "read" references
            LspReferenceRead = { style = "underline", sp = colors.yellow },
            -- used for highlighting "write" references
            LspReferenceWrite = { style = "underline", sp = colors.yellow },

            LspSignatureActiveParameter = { fg = colors.none, bg = colors.highlight_dark, style = "bold" },
            LspCodeLens = { fg = colors.light_gray },
            LspInlayHint = { fg = colors.light_gray, bg = colors.active },

            -- LSP Semantic Token Groups
            ["@lsp.type.namespace"] = { link = "@namespace" },
            ["@lsp.type.type"] = { link = "@type" },
            ["@lsp.type.class"] = { link = "@type" },
            ["@lsp.type.enum"] = { link = "@type" },
            ["@lsp.type.interface"] = { link = "@type" },
            ["@lsp.type.struct"] = { link = "@type" },
            ["@lsp.type.typeParameter"] = { link = "@type" },
            ["@lsp.type.parameter"] = { link = "@parameter" },
            ["@lsp.type.variable"] = { link = "@variable" },
            ["@lsp.type.property"] = { link = "@property" },
            ["@lsp.type.enumMember"] = { link = "@constant" },
            ["@lsp.type.function"] = { link = "@function" },
            ["@lsp.type.method"] = { link = "@method" },
            ["@lsp.type.macro"] = { link = "@constant.macro" },
            ["@lsp.type.keyword"] = { link = "@keyword" },
            ["@lsp.type.comment"] = { link = "@comment" },
            ["@lsp.type.string"] = { link = "@string" },
            ["@lsp.type.number"] = { link = "@number" },
            ["@lsp.type.regexp"] = { link = "@string.regex" },
            ["@lsp.type.operator"] = { link = "@operator" },
            ["@lsp.type.decorator"] = { link = "@function.macro" },
            ["@lsp.mod.deprecated"] = { style = "strikethrough" },
            ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
            ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
            ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },

            DiagnosticError = { link = "LspDiagnosticsDefaultError" },
            DiagnosticWarn = { link = "LspDiagnosticsDefaultWarning" },
            DiagnosticInfo = { link = "LspDiagnosticsDefaultInformation" },
            DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
            DiagnosticVirtualTextWarn = { link = "LspDiagnosticsVirtualTextWarning" },
            DiagnosticUnderlineWarn = { link = "LspDiagnosticsUnderlineWarning" },
            DiagnosticFloatingWarn = { link = "LspDiagnosticsFloatingWarning" },
            DiagnosticSignWarn = { link = "LspDiagnosticsSignWarning" },
            DiagnosticVirtualTextError = { link = "LspDiagnosticsVirtualTextError" },
            DiagnosticUnderlineError = { link = "LspDiagnosticsUnderlineError" },
            DiagnosticFloatingError = { link = "LspDiagnosticsFloatingError" },
            DiagnosticSignError = { link = "LspDiagnosticsSignError" },
            DiagnosticVirtualTextInfo = { link = "LspDiagnosticsVirtualTextInformation" },
            DiagnosticUnderlineInfo = { link = "LspDiagnosticsUnderlineInformation" },
            DiagnosticFloatingInfo = { link = "LspDiagnosticsFloatingInformation" },
            DiagnosticSignInfo = { link = "LspDiagnosticsSignInformation" },
            DiagnosticVirtualTextHint = { link = "LspDiagnosticsVirtualTextHint" },
            DiagnosticUnderlineHint = { link = "LspDiagnosticsUnderlineHint" },
            DiagnosticFloatingHint = { link = "LspDiagnosticsFloatingHint" },
            DiagnosticSignHint = { link = "LspDiagnosticsSignHint" },
        }

        return lsp
    end

    local function load_plugins()
        -- Plugins highlight groups

        local plugins = {
            -- Cmp
            CmpItemAbbr = { fg = colors.fg },
            CmpItemAbbrDeprecated = { fg = colors.fg },
            CmpItemAbbrMatch = { fg = colors.cyan, style = "bold" },
            CmpItemAbbrMatchFuzzy = { fg = colors.cyan, underline = true },
            CmpItemMenu = { fg = colors.gray },

            CmpItemKindText = { fg = colors.gray },
            CmpItemKindMethod = { fg = colors.gray },
            CmpItemKindFunction = { fg = colors.gray },
            CmpItemKindConstructor = { fg = colors.gray },
            CmpItemKindField = { fg = colors.gray },
            CmpItemKindClass = { fg = colors.gray },
            CmpItemKindInterface = { fg = colors.gray },
            CmpItemKindModule = { fg = colors.gray },
            CmpItemKindProperty = { fg = colors.gray },
            CmpItemKindValue = { fg = colors.gray },
            CmpItemKindEnum = { fg = colors.gray },
            CmpItemKindKeyword = { fg = colors.gray },
            CmpItemKindSnippet = { fg = colors.gray },
            CmpItemKindFile = { fg = colors.gray },
            CmpItemKindEnumMember = { fg = colors.gray },
            CmpItemKindConstant = { fg = colors.gray },
            CmpItemKindStruct = { fg = colors.gray },
            CmpItemKindTypeParameter = { fg = colors.gray },
            CmpItemKindCopilot = { fg = colors.gray },

            -- Neogit
            NeogitSectionHeader = { fg = colors.fg, style = "bold" },
            NeogitBranch = { fg = colors.green },
            NeogitRemote = { fg = colors.purple },
            NeogitHunkHeader = { fg = colors.fg, bg = colors.active },
            NeogitHunkHeaderHighlight = { fg = colors.cyan, bg = colors.active },
            NeogitDiffContextHighlight = { bg = colors.active },
            NeogitDiffDeleteHighlight = { fg = colors.diff_remove, bg = colors.diff_remove_bg },
            NeogitDiffAddHighlight = { fg = colors.diff_add, bg = colors.diff_add_bg },

            NeogitGraphBlack = { fg = colors.fg },
            NeogitGraphBlackBold = { fg = colors.fg, style = "bold" },
            NeogitGraphRed = { fg = colors.dark_red },
            NeogitGraphRedBold = { fg = colors.dark_red, style = "bold" },
            NeogitGraphGreen = { fg = colors.green },
            NeogitGraphGreenBold = { fg = colors.green, style = "bold" },
            NeogitGraphYellow = { fg = colors.yellow },
            NeogitGraphYellowBold = { fg = colors.yellow, style = "bold" },
            NeogitGraphBlue = { fg = colors.dark_blue },
            NeogitGraphBlueBold = { fg = colors.dark_blue, style = "bold" },
            NeogitGraphPurple = { fg = colors.purple },
            NeogitGraphPurpleBold = { fg = colors.purple, style = "bold" },
            NeogitGraphCyan = { fg = colors.cyan },
            NeogitGraphCyanBold = { fg = colors.cyan, style = "bold" },
            NeogitGraphWhite = { fg = colors.bg },
            NeogitGraphWhiteBold = { fg = colors.bg, style = "bold" },
            NeogitGraphGray = { fg = colors.gray },
            NeogitGraphBoldGray = { fg = colors.gray, style = "bold" },
            NeogitGraphOrange = { fg = colors.light_red },
            NeogitGraphBoldOrange = { fg = colors.light_red, style = "bold" },

            NeogitNotificationInfo = { fg = colors.info },
            NeogitNotificationWarning = { fg = colors.warn },
            NeogitNotificationError = { fg = colors.error },

            -- GitSigns
            GitSignsAdd = { fg = colors.diff_add_bg },       -- diff mode: Added line |diff.txt|
            GitSignsAddNr = { fg = colors.diff_add },        -- diff mode: Added line |diff.txt|
            GitSignsAddLn = { fg = colors.diff_add },        -- diff mode: Added line |diff.txt|
            GitSignsChange = { fg = colors.diff_change_bg }, -- diff mode: Changed line |diff.txt|
            GitSignsChangeNr = { fg = colors.diff_change },  -- diff mode: Changed line |diff.txt|
            GitSignsChangeLn = { fg = colors.diff_change },  -- diff mode: Changed line |diff.txt|
            GitSignsDelete = { fg = colors.diff_remove_bg }, -- diff mode: Deleted line |diff.txt|
            GitSignsDeleteNr = { fg = colors.diff_remove },  -- diff mode: Deleted line |diff.txt|
            GitSignsDeleteLn = { fg = colors.diff_remove },  -- diff mode: Deleted line |diff.txt|

            -- Telescope
            TelescopeNormal = { fg = colors.fg, bg = colors.bg },
            TelescopePromptPrefix = { fg = colors.purple },
            TelescopePromptBorder = { fg = colors.gray },
            TelescopeResultsBorder = { fg = colors.gray },
            TelescopePreviewBorder = { fg = colors.gray },
            TelescopeSelectionCaret = { fg = colors.cyan },
            TelescopeSelection = { fg = colors.cyan },
            TelescopeMatching = { fg = colors.yellow, style = "bold" },

            -- NvimTree
            NvimTreeRootFolder = { fg = colors.fg, style = "bold" },
            NvimTreeFolderName = { fg = colors.fg },
            NvimTreeFolderIcon = { fg = colors.gray },
            NvimTreeEmptyFolderName = { fg = colors.gray },
            NvimTreeOpenedFolderName = { fg = colors.fg },
            NvimTreeGitDirty = { fg = colors.gray },
            NvimTreeGitNew = { fg = colors.gray },
            NvimTreeGitStaged = { fg = colors.gray },
            NvimTreeGitDeleted = { fg = colors.gray },
            NvimTreeExecFile = { fg = colors.fg },
            NvimTreeOpenedFile = { fg = colors.fg },
            NvimTreeSpecialFile = { fg = colors.fg },
            NvimTreeImageFile = { fg = colors.fg },
            NvimTreeNormal = { fg = colors.fg },
            NvimTreeCursorLine = { fg = colors.cyan, bg = colors.float, style = "bold" },

            LspDiagnosticsError = { fg = colors.error },
            LspDiagnosticsWarning = { fg = colors.warn },
            LspDiagnosticsInformation = { fg = colors.info },
            LspDiagnosticsHint = { fg = colors.hint },

            -- WhichKey
            WhichKey = { fg = colors.cyan, style = "bold" },
            WhichKeyGroup = { fg = colors.gray },
            WhichKeyDesc = { fg = colors.fg, style = "italic" },
            WhichKeySeperator = { fg = colors.green },
            WhichKeyFloat = { bg = colors.float },

            -- nvim-treesitter-context
            TreesitterContext = { fg = colors.none, bg = colors.active },

            -- Indent Blankline
            IndentBlanklineChar = { fg = colors.new_light_gray, style = "nocombine" },
            IndentBlanklineSpaceChar = { fg = colors.new_light_gray, style = "nocombine" },
            IndentBlanklineSpaceCharBlankline = { fg = colors.new_light_gray, style = "nocombine" },
            IndentBlanklineContextChar = { fg = colors.new_light_gray, style = "nocombine" },
            IndentBlanklineContextStart = { style = "underline", sp = colors.purple },

            -- Nvim dap
            -- DapBreakpoint = { fg = colors.red },
            -- DapStopped = { fg = colors.green },

            -- Diffview
            DiffviewFilePanelSelected = { fg = colors.cyan, style = "bold" },
            DiffviewFolderSign = { fg = colors.gray },

            LeapLabelPrimary = { fg = colors.fg, bg = colors.search, style = "bold" },

            LuaLineDiffAdd = { fg = colors.diff_add },
            LuaLineDiffChange = { fg = colors.diff_change },
            LuaLineDiffDelete = { fg = colors.diff_remove },
        }

        return plugins
    end

    function theme.load_terminal()
        -- light
        vim.g.terminal_color_7 = colors.fg
        vim.g.terminal_color_15 = colors.fg_light

        -- colors
        vim.g.terminal_color_1 = colors.red
        vim.g.terminal_color_9 = colors.red

        vim.g.terminal_color_2 = colors.green
        vim.g.terminal_color_10 = colors.green

        vim.g.terminal_color_3 = colors.yellow
        vim.g.terminal_color_11 = colors.yellow

        vim.g.terminal_color_4 = colors.blue
        vim.g.terminal_color_12 = colors.blue

        vim.g.terminal_color_5 = colors.purple
        vim.g.terminal_color_13 = colors.purple

        vim.g.terminal_color_6 = colors.cyan
        vim.g.terminal_color_14 = colors.cyan
    end

    return vim.tbl_deep_extend("error", load_syntax(), load_editor(), load_treesitter(), load_lsp(), load_plugins())
end

return theme
