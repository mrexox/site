(in-package #:ian.mrexox.site)

(define-ennasy-handler (posts :uri "/posts.json") (page)
  (setf (content-type*) "application/json")
  (let ((posts (list
		(make-instance 'post :title "New post!" :text "My new text" :likes 90)
		(make-instance 'post :title "New brand post!" :text "Another text")
		(make-instance 'post :title "At last post!" :text "One more time" :likes 10)))
	js)
    (setf js (new-js ("data" (loop for post in posts collect (serialize post)))))
    
    (format nil (to-json js))))

;;; TEST

(defparameter *handlers* (make-hash-table))

(defmacro def-handler (hname paramlist &body body)
  (setf (gethash hname *handlers*)
	`((:params . ',paramlist)
	  (:body . ',body))))

(defmacro def-routes (&rest forms))
  

(def-handler posts (param1 param2 param3))

(def-routes
  (:get "/posts" posts)
  (:get "/lalas" lalas)
  (:post "/new-page" new-page))

