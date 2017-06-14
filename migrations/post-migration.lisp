(in-package #:ian.mrexox.site)

;; Creating table Post
(execute (dao-table-definition 'post))

(insert-dao (make-instance 'post
			   :title "New post 1"
			   :text "Hello, guyes!"))

(insert-dao (make-instance 'post
			   :title "New post 2"
			   :text "Hello, guyes, glad to head about you!"))
