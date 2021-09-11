function dribbblish
    spicetify config extensions dribbblish.js
    spicetify config current_theme Dribbblish color_scheme $argv
    spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
    spicetify apply
end
