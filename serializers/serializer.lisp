(in-package :ian.mrexox.site)

;; Serializer instance
;  (def-serializer post-serializer
;    :attrs ('id 'title 'text 'created-at 'permalink)
;    :key (('id . "my-id"))
;    :has-many ('tags))


(defclass serializer ()
  ((name :initarg :name
	 :initform (error "A serializer must have a name"))
   (attrs :initarg :attrs
	  ;; Attrs is an a-list with (attr-name . attr-json-key)
	  :initform (list (cons id "id"))
	  :reader attrs)
   (relationships :initarg :relationships
		 :initform nil
		 :reader relationships)))

(defmacro def-serializer ((object) &key (attrs '(id . "id")) key has-many)
  (mapcar #'(lambda (symbol) (push (cons symbol (string-downcase (symbol-name symbol))) attrs))
	  attrs)
  (mapcar #'(lambda (cons) (setf (cdr (assoc (car cons) attrs)) (cdr cons)))
	  key)
  (push (make-instance 'serializer
		       :name (symbol-name name)
		       :attrs attrs)))
		       
  
  
  

(defun pluralize (str)
  (concatenate 'string str "s"))

(defun object-type-string (obj)
  (string-downcase (symbol-name (type-of obj))))

(defun jsonapi-type (obj)
  (pluralize (object-type-string obj)))

(defgeneric serialize (serializer obj)
  (:documentation  "Returns a JSON-string serialized with JSONAPI"))

(defun attrs-js (attrs)
  `(:obj ,@(loop for i in attrs collect (cons (car i) (cadr i)))))

(defmethod serialize ((serializer serializer) obj)
  (let ((attributes (attrs serializer))
	(json-attrs))
    ;; Add relationships
    (setf json-attrs (attrs-js (loop for attr in attributes
		      collect (list (cdr attr) (slot-value obj (car attr))))))
    (jsown:new-js
      ("data" (new-js
	       ("type" (jsonapi-type obj)) ;; FIXME maybe use name attribute?
	       ("id" (slot-value obj 'id ))
	       ("attributes" json-attrs))))))
