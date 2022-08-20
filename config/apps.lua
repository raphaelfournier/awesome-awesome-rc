local _M = {
   terminal = terminal or os.getenv('TERMINAL') or 'xterm',
   editor   = os.getenv('EDITOR')   or 'nano',
}

_M.editor_cmd = _M.terminal .. ' -e ' .. _M.editor
_M.manual_cmd = _M.terminal .. ' -e man awesome'
_M.screenlock_cmd = "xautolock -locknow"

return _M
