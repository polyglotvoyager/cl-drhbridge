(defvar *server* nil)
(defvar *port* 8100)
(defvar *address* "::")

(defclass chat-room (hunchensocket:websocket-resource)
  ((name :initarg :name :initform (error "name this room") :reader name))
  (:default-initargs :client-class 'user))

(defclass user (hunchensocket:websocket-client)
  ((name :initarg :user-agent :reader name :initform (error "name this user"))
   (username :accessor username :initform nil)))

(defvar *chat-rooms* (list (make-instance 'chat-room :name "/drhbridge/ws")))

(defun find-room (request) (find (hunchentoot:script-name request) *chat-rooms* :test #'string= :key #'name))

(pushnew 'find-room hunchensocket:*websocket-dispatch-table*)

(defun broadcast (room message &rest args)
  (loop for peer in (hunchensocket:clients room)
        do (hunchensocket:send-text-message peer (apply #'format nil message args))))

(defmethod hunchensocket:client-connected ((room chat-room) user)
  (let ((username (hunchentoot:parameter "username" (hunchensocket:client-request user))))
    (setf (username user) username)
    (broadcast room "~a has joined ~a" username (name room))))

(defmethod hunchensocket:client-disconnected ((room chat-room) user)
  (broadcast room "~a has left" (username user)))

(defmethod hunchensocket:text-message-received ((room chat-room) user message)
  (broadcast room "~a says ~a" (username user) message))

(defclass my-acceptor
    (hunchensocket:websocket-acceptor
     hunchentoot:easy-acceptor)
  ())

(setf *server* (make-instance 'my-acceptor :port *port* :address *address*))

(hunchentoot:define-easy-handler (play :uri "/drhbridge/play") ()
  (setf (hunchentoot:content-type*) "text/html")
  *play-html*)

(hunchentoot:start *server*)
