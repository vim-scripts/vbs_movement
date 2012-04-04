" vbs_movement.vim: Movement over VBScript classes / functions / properties / subs with ]m etc.
"
" This filetype plugin provides movement commands and text objects for Visual
" Basic Script classes, functions, properties, and subs.
"
" DEPENDENCIES:
"   - CountJump.vim, CountJump/Motion.vim, CountJump/TextObjects.vim autoload
"     scripts
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.003	04-Apr-2012	Add movement and text objects for classes, too.
"				It's hard to find a good mnemonic, as ]c is
"				already taken. I chose ]gm, as a "g" prefix
"				generally overloads a mapping, and it can be
"				read as "greater [than] method".
"	002	03-Apr-2012	Add special for WSH filetype to also move to
"				JavaScript functions, as in
"				javascript_movement.vim.
"	001	03-Apr-2012	file creation from vim_movement.vim

" Avoid installing when in unsupported Vim version.
if v:version < 700
    finish
endif

let s:patternFunctionBegin = '\c^\s*\%(\%(public\|private\)\s\+\)\?\%(function\|property \%(get\|set\)\|sub\)\>'
let s:patternFunctionEnd = '^\c\s*end \%(function\|property\|sub\)\>'
let s:patternClassBegin = '\c^\s*\%(\%(public\|private\)\s\+\)\?class\>'
let s:patternClassEnd = '^\c\s*end class\>'

"			Move around VBScript functions, properties and subs:
"]m			Go to [count] next start of a function / property / sub.
"]M			Go to [count] next end of a function / property / sub.
"[m			Go to [count] previous start of a function / property / sub.
"[M			Go to [count] previous end of a function / property / sub.

"]gm			Go to [count] next start of a class.
"]gM			Go to [count] next end of a class.
"[gm			Go to [count] previous start of a class.
"[gM			Go to [count] previous end of a class.

let s:patternJavaScriptFunctionBegin = ''
if &l:filetype ==# 'wsh'
    let s:patternJavaScriptFunctionBegin = '\|\<function('
endif
call CountJump#Motion#MakeBracketMotion('<buffer>',  'm',  'M', s:patternFunctionBegin . s:patternJavaScriptFunctionBegin, s:patternFunctionEnd, 0)
call CountJump#Motion#MakeBracketMotion('<buffer>', 'gm', 'gM', s:patternClassBegin, s:patternClassEnd, 0)

"im			"inner method" text object, select [count] function /
"			property / sub contents.
"am			"a method" text object, select [count] function /
"			property / subs, including the function / property / sub
"			definition and 'end ...'.

"igm			"inner class" text object, select [count] class contents.
"agm			"a class" text object, select [count] classes, including
"			the class definition and "end class"
call CountJump#TextObject#MakeWithCountSearch('<buffer>',  'm', 'ai', 'V', s:patternFunctionBegin, s:patternFunctionEnd)
call CountJump#TextObject#MakeWithCountSearch('<buffer>', 'gm', 'ai', 'V', s:patternClassBegin, s:patternClassEnd)

unlet s:patternJavaScriptFunctionBegin
unlet s:patternFunctionBegin
unlet s:patternFunctionEnd
unlet s:patternClassBegin
unlet s:patternClassEnd

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
