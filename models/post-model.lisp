(in-package :ian.mrexox.site)

(defvar *post-ids* 0)

(defclass post ()
  ((id :col-type integer)
   (title :col-type string
	  :initarg :title
	  :accessor title
	  :initform (error "Post must have a Title"))
   (text :col-type (or db-null text)
	 :initarg :text
	 :accessor text)
   (likes :col-type integer
	  :initform 0)
   (created-at :col-type timestamp
	       :initform (simple-date:universal-time-to-timestamp
                          (local-time:timestamp-to-universal
                           (local-time:now)))
	       :reader created-at))
  (:metaclass dao-class)
  (:keys id))

(defmethod initialize-instance :after ((post post) &key)
  (setf (slot-value post 'id) (incf *post-ids*)))
