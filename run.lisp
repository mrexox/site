(require :asdf)
(asdf:load-system :postmodern)
(asdf:load-system :hunchentoot)
(asdf:load-system :jsown)
(asdf:load-system :s-sql)
(asdf:load-system :local-time)
(asdf:load-system :simple-date)

(load "~/src/lisp/site/packages.lisp")

(in-package :ian.mrexox.site)

(defvar *acceptor* (make-instance 'easy-acceptor :port 4242))

(load "~/src/lisp/site/models/post-model.lisp")
(load "~/src/lisp/site/serializers/serializer.lisp")

(start *acceptor*)
