(defpackage :drhbridge
  (:use :cl)
  (:export #:start-server #:stop-server))

(asdf:defsystem "drhbridge"
  :version "0.0.1"
  :author "Heitor Chang"
  :license "MIT"
  :depends-on ("hunchentoot"
               "hunchensocket")
  :components ((:module "src"
                :components
                ((:file "pages")
                 (:file "app"))))
  :description "Dr. H. Bridge webapp")
