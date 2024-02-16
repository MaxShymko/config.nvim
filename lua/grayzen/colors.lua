local colors = {
  -- old colors. should be removed
  light_gray = '#19F8FF',
  red = '#FF0000',
  pink = '#E85B7A',
  dark_pink = '#E44675',
  orange = '#EE5E25',
  light_purple = '#FF47AD',

  fg = '#262626',
  bg = '#FAFBFC',
  gray = '#808080',
  new_light_gray = '#ECECEC',
  cyan = '#458383',
  blue = '#1740E6',
  dark_blue = '#071591', -- keywords
  light_blue = '#CAD9FA',
  green = '#106B10', -- strings
  light_green = '#BEE6BE', -- diff add
  dark_red = '#AA3731',
  light_red = '#FFD5CC',
  yellow = '#CB9000',
  purple = '#660E7A',
  none = 'NONE',
}

-- more semantically meaningful colors
colors.error = colors.dark_red
colors.warn = colors.yellow
colors.info = '#4585BE'
colors.hint = '#4585BE'

colors.link = '#4585BE'

colors.diff_add = colors.green
colors.diff_add_bg = '#BEE6BE'
colors.diff_change = colors.dark_blue
colors.diff_change_bg = '#CAD9FA'
colors.diff_remove = colors.dark_red
colors.diff_remove_bg = '#FFD5CC'
colors.diff_text_bg = '#B8CBF5'

colors.active = '#F2F3F5'
colors.float = '#F5F7F8'
colors.highlight = colors.light_blue
colors.highlight_dark = '#DFE1E4'
colors.search = '#BFDEBA'

return colors
