; Auto-generated. Do not edit!


(cl:in-package braccio_controller-msg)


;//! \htmlinclude coords.msg.html

(cl:defclass <coords> (roslisp-msg-protocol:ros-message)
  ((x
    :reader x
    :initarg :x
    :type cl:fixnum
    :initform 0)
   (y
    :reader y
    :initarg :y
    :type cl:fixnum
    :initform 0)
   (z
    :reader z
    :initarg :z
    :type cl:fixnum
    :initform 0)
   (angle
    :reader angle
    :initarg :angle
    :type cl:fixnum
    :initform 0)
   (wrist
    :reader wrist
    :initarg :wrist
    :type cl:fixnum
    :initform 0)
   (real
    :reader real
    :initarg :real
    :type cl:boolean
    :initform cl:nil)
   (gripper
    :reader gripper
    :initarg :gripper
    :type cl:fixnum
    :initform 0))
)

(cl:defclass coords (<coords>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <coords>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'coords)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name braccio_controller-msg:<coords> is deprecated: use braccio_controller-msg:coords instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:x-val is deprecated.  Use braccio_controller-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:y-val is deprecated.  Use braccio_controller-msg:y instead.")
  (y m))

(cl:ensure-generic-function 'z-val :lambda-list '(m))
(cl:defmethod z-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:z-val is deprecated.  Use braccio_controller-msg:z instead.")
  (z m))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:angle-val is deprecated.  Use braccio_controller-msg:angle instead.")
  (angle m))

(cl:ensure-generic-function 'wrist-val :lambda-list '(m))
(cl:defmethod wrist-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:wrist-val is deprecated.  Use braccio_controller-msg:wrist instead.")
  (wrist m))

(cl:ensure-generic-function 'real-val :lambda-list '(m))
(cl:defmethod real-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:real-val is deprecated.  Use braccio_controller-msg:real instead.")
  (real m))

(cl:ensure-generic-function 'gripper-val :lambda-list '(m))
(cl:defmethod gripper-val ((m <coords>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader braccio_controller-msg:gripper-val is deprecated.  Use braccio_controller-msg:gripper instead.")
  (gripper m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <coords>) ostream)
  "Serializes a message object of type '<coords>"
  (cl:let* ((signed (cl:slot-value msg 'x)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'y)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'z)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'angle)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'wrist)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'real) 1 0)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'gripper)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <coords>) istream)
  "Deserializes a message object of type '<coords>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'x) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'y) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'z) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'angle) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'wrist) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
    (cl:setf (cl:slot-value msg 'real) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'gripper)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<coords>)))
  "Returns string type for a message object of type '<coords>"
  "braccio_controller/coords")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'coords)))
  "Returns string type for a message object of type 'coords"
  "braccio_controller/coords")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<coords>)))
  "Returns md5sum for a message object of type '<coords>"
  "865536847ef9cce2f44ef34a4baed036")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'coords)))
  "Returns md5sum for a message object of type 'coords"
  "865536847ef9cce2f44ef34a4baed036")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<coords>)))
  "Returns full string definition for message of type '<coords>"
  (cl:format cl:nil "int16 x~%int16 y~%int16 z~%int8 angle~%int8 wrist~%bool real~%uint8 gripper~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'coords)))
  "Returns full string definition for message of type 'coords"
  (cl:format cl:nil "int16 x~%int16 y~%int16 z~%int8 angle~%int8 wrist~%bool real~%uint8 gripper~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <coords>))
  (cl:+ 0
     2
     2
     2
     1
     1
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <coords>))
  "Converts a ROS message object to a list"
  (cl:list 'coords
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':z (z msg))
    (cl:cons ':angle (angle msg))
    (cl:cons ':wrist (wrist msg))
    (cl:cons ':real (real msg))
    (cl:cons ':gripper (gripper msg))
))
