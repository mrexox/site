(in-package #:ian.mrexox.site)

(define-easy-handler (posts :uri "/posts") (page)
  (setf (content-type*) "application/json")
  (format
   nil
   (to-json
    (new-js
      ("data"
       (list (new-js
	       ("title" "Hello, world!")
	       ("likes" 0)
	       ("text" "This is my first post handled by CL")
	       ("tags" '("new-post" "common-lisp" "happy-coding")))
	     (new-js
	       ("title" "Hi, man!")
	       ("likes" 10)
	       ("text" "This is another place for a post")
	       ("tags" '("need-to-make-it-clean" "create-a-model" "and-make-a-serializer")))))))))
