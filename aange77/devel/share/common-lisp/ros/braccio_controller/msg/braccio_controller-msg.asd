
(cl:in-package :asdf)

(defsystem "braccio_controller-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "Adc" :depends-on ("_package_Adc"))
    (:file "_package_Adc" :depends-on ("_package"))
  ))