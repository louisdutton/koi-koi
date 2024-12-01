ls assets/svg | get name | each { |path| resvg $path ($path | str replace "svg" "png")}
