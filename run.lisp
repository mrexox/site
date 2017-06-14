(require :asdf)
(asdf:load-system :postmodern)
(asdf:load-system :hunchentoot)
(asdf:load-system :jsown)
(asdf:load-system :s-sql)
(asdf:load-system :local-time)

(load "~/src/lisp/site/packages.lisp")

(in-package :ian.mrexox.site)

(defvar *acceptor* (make-instance 'easy-acceptor :port 4242))

(start *acceptor*)
