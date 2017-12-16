(require :asdf)
(asdf:load-system :postmodern)
(asdf:load-system :hunchentoot)
(asdf:load-system :jsown)
(asdf:load-system :s-sql)
(asdf:load-system :local-time)
(asdf:load-system :simple-date)

(defparameter cwd (truename "."))

(load (merge-pathnames cwd #P"packages.lisp"))

(in-package :ian.mrexox.site)
(defparameter cwd (truename "."))

(defvar *acceptor* (make-instance 'easy-acceptor :port 4242))

(load (merge-pathnames #P"models/post-model.lisp" cwd))
(load (merge-pathnames #P"serializers/serializer.lisp" cwd))

(start *acceptor*)
