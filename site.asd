(require :asdf)
(asdf:defsystem #:site
  :description "Ian Mrexox Own Site"
  :version "0.0.1"
  :author "Ian K <mrexox@outlook.com>"
  :licence "No"
  :depends-on (#:postmodern
	       #:jsown
	       #:s-sql
	       #:hunchentoot
	       #:local-time
	       #:simple-dat)
  :components ((:file "packages")
	       (:module "serializers"
			:components ((:file "serializer" :depends-on ("packages"))))
	       (:module "migrations"
			:components (:file "post-migration" :depends-on ("packages" "post-model")))
	       (:module "models"
			:components ((:file "post-model" :depends-on ("packages"))))
	       (:module "controllers"
			:components ((:file "controller" :depends-on ("packages"))))))
		     
