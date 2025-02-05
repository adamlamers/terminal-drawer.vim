function terminal_drawer#ToggleTerminal() abort
  let l:termNums = term_list()
  let l:termWins = filter(getwininfo(), 'v:val.terminal')
  let l:currentBufNum = bufnr('%')
  if index(l:termNums, l:currentBufNum) >= 0
      " current buffer is terminal, hide it
      execute 'hid'
  elseif len(l:termWins) > 0
      " there is a terminal buffer, show it
      execute 'tabn' . l:termWins[0].tabnr
      execute l:termWins[0].winnr . 'wincmd w'
  elseif len(l:termNums) > 0
      " the terminal buffer is hidden, show it
      execute 'sb ' . l:termNums[0]
  else
      " no terminal buffer, create one
      let l:cmd = get(g:, 'terminal_drawer_shell', '')
      let l:new_buf = -1

      let l:options = {}
      let l:options.term_name = "terminal-drawer"
      let l:options.term_finish = "close"

      if len(l:cmd) > 0
        let l:new_buf = term_start(l:cmd, l:options)
      else
        let l:new_buf = term_start(environ()["SHELL"], l:options)
      endif

      if l:new_buf > 0 && g:terminal_drawer_start_nobuflisted > 0
          call setbufvar(l:new_buf, "&buflisted", 0)
      endif
  endif
endfunction
