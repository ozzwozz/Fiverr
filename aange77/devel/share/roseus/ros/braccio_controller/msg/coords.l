;; Auto-generated. Do not edit!


(when (boundp 'braccio_controller::coords)
  (if (not (find-package "BRACCIO_CONTROLLER"))
    (make-package "BRACCIO_CONTROLLER"))
  (shadow 'coords (find-package "BRACCIO_CONTROLLER")))
(unless (find-package "BRACCIO_CONTROLLER::COORDS")
  (make-package "BRACCIO_CONTROLLER::COORDS"))

(in-package "ROS")
;;//! \htmlinclude coords.msg.html


(defclass braccio_controller::coords
  :super ros::object
  :slots (_x _y _z _angle _wrist _real _gripper ))

(defmethod braccio_controller::coords
  (:init
   (&key
    ((:x __x) 0)
    ((:y __y) 0)
    ((:z __z) 0)
    ((:angle __angle) 0)
    ((:wrist __wrist) 0)
    ((:real __real) nil)
    ((:gripper __gripper) 0)
    )
   (send-super :init)
   (setq _x (round __x))
   (setq _y (round __y))
   (setq _z (round __z))
   (setq _angle (round __angle))
   (setq _wrist (round __wrist))
   (setq _real __real)
   (setq _gripper (round __gripper))
   self)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:z
   (&optional __z)
   (if __z (setq _z __z)) _z)
  (:angle
   (&optional __angle)
   (if __angle (setq _angle __angle)) _angle)
  (:wrist
   (&optional __wrist)
   (if __wrist (setq _wrist __wrist)) _wrist)
  (:real
   (&optional (__real :null))
   (if (not (eq __real :null)) (setq _real __real)) _real)
  (:gripper
   (&optional __gripper)
   (if __gripper (setq _gripper __gripper)) _gripper)
  (:serialization-length
   ()
   (+
    ;; int16 _x
    2
    ;; int16 _y
    2
    ;; int16 _z
    2
    ;; int8 _angle
    1
    ;; int8 _wrist
    1
    ;; bool _real
    1
    ;; uint8 _gripper
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int16 _x
       (write-word _x s)
     ;; int16 _y
       (write-word _y s)
     ;; int16 _z
       (write-word _z s)
     ;; int8 _angle
       (write-byte _angle s)
     ;; int8 _wrist
       (write-byte _wrist s)
     ;; bool _real
       (if _real (write-byte -1 s) (write-byte 0 s))
     ;; uint8 _gripper
       (write-byte _gripper s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int16 _x
     (setq _x (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _y
     (setq _y (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _z
     (setq _z (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int8 _angle
     (setq _angle (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _angle 127) (setq _angle (- _angle 256)))
   ;; int8 _wrist
     (setq _wrist (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _wrist 127) (setq _wrist (- _wrist 256)))
   ;; bool _real
     (setq _real (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; uint8 _gripper
     (setq _gripper (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get braccio_controller::coords :md5sum-) "865536847ef9cce2f44ef34a4baed036")
(setf (get braccio_controller::coords :datatype-) "braccio_controller/coords")
(setf (get braccio_controller::coords :definition-)
      "int16 x
int16 y
int16 z
int8 angle
int8 wrist
bool real
uint8 gripper
")



(provide :braccio_controller/coords "865536847ef9cce2f44ef34a4baed036")


