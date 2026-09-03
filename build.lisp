(asdf:load-system :drhbridge)

(sb-ext:save-lisp-and-die "drhbridge.exe"
                          :toplevel #'drhbridge::start-server
                          :executable t
                          :compression t)
