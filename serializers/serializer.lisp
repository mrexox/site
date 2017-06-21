(in-package :ian.mrexox.site)
;;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;; THIS IS SERIALIZER MAIN DESCRIPTION
;;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;; Serializer makes an object of certain class representation
;;; into JSON format.
;;; For this version only JSON-API adapter is implemented
;;; The only slot a class must have is - id

;;; EXAMPLE
;;  ::::::::::::::::::::::::::::::::::::::::::::::::::
;;  Serializer instance
;;  ::::::::::::::::::::::::::::::::::::::::::::::::::
;;  (def-serializer post
;;    :attrs ('id 'title 'text 'created-at 'permalink)
;;    :key (('id . "my-id"))
;;    :has-many ('tags))
;;  ::::::::::::::::::::::::::::::::::::::::::::::::::

(defvar *serializers* nil)

(defclass serializer ()
  ((name :initarg :name
	 :initform (error "A serializer must have a name")
	 :reader name)
   (attrs :initarg :attrs
	  ;; Attrs is an a-list with (attr-name . attr-json-key)
	  :initform (list (cons 'id "id"))
	  :reader attrs)
   (relationships :initarg :relationships
		 :initform nil
		 :reader relationships)))

(defun find-serializer (symbol)
  (find symbol  *serializers* :key #'(lambda (ser) (name ser)) :test #'string-equal))
  
(defun find-serializer-for (object)
  (find-serializer (symbol-name object)))

(defun def-serializer (name &key (attrs '(id)) key)
  (let ((attributes nil)
	(ser (find-serializer name)))
    (if ser (setf *serializers* (remove ser *serializers*)))
    (mapcar #'(lambda (symbol) (push (cons symbol (string-downcase (symbol-name symbol))) attributes))
	    attrs)
    (mapcar #'(lambda (cons)
		(let ((key (assoc (car cons) attributes)))
		  (when key
		      (setf (cdr (assoc (car cons) attributes)) (cdr cons)))))
	    key)
    (push (make-instance 'serializer
			  :name (symbol-name name)
			  :attrs attributes)
	  *serializers*)))


(defun pluralize (str)
  (concatenate 'string str "s"))

(defun object-type-string (obj)
  (string-downcase (symbol-name (type-of obj))))

(defun jsonapi-type (obj)
  (pluralize (object-type-string obj)))

(defgeneric do-serialize (serializer obj)
  (:documentation  "Returns a JSON-string serialized with JSONAPI"))

(defun attrs-js (attrs)
  `(:obj ,@(loop for i in attrs collect (cons (car i) (cadr i)))))

(defun timestamp-to-string (timestamp)
  (let ((fs (make-array '(0) :element-type 'base-char
                             :fill-pointer 0 :adjustable t)))
    (with-output-to-string (s fs)
      (multiple-value-bind (second minute hour date month year)
	  (decode-universal-time (simple-date:timestamp-to-universal-time timestamp))
	(format s "~a:~a:~a ~a-~a-~a" hour minute second date month year)))
    fs))

(defmethod do-serialize ((serializer serializer) obj)
  "Creates the jsown:new-js object with JSON API"
  (let ((attributes (attrs serializer))
	(json-attrs))
    ;; Add relationships
    (setf json-attrs (attrs-js (loop for attr in attributes
				  collect (list (cdr attr) (let ((slot (slot-value obj (car attr))))
							     (if (eql (type-of slot)
								      'simple-date:timestamp)
								 (timestamp-to-string slot)
								 slot))))))
    (jsown:new-js
	       ("type" (jsonapi-type obj)) ;; FIXME maybe use name attribute?
	       ("id" (slot-value obj 'id ))
	       ("attributes" json-attrs))))

;; Public
(defun serialize (object)
  (let ((serializer (find-serializer-for (type-of object))))
    (if serializer
	(do-serialize serializer object)
	(error (concatenate 'string "No such a serializer: " (symbol-name (type-of object)))))))
