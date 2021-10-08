import random
import math

class Snaking(Cleaner):
    def __init__(self, x,y,radius,color,ang, speed):
        #super(x,y,radius,color,ang,speed)
        self.walling = false
        self.old_x = x
        self.old_y = y
        self.old_ang = ang
        self.last_dir()

    def last_dir(self):
        if(random.random() > 0.5) :
            self.last_dir = 1
        else:
            self.last_dir = 0

    def store_wall(self, side):
        self.coll = side
        self.old_x = self.x
        self.old_y = self.y
        self.walling = true
        self.old_ang = self.ang
        if(self.coll == "t"):
            if(self.last_dir):
                super().rotate(math.pi)
            else:
                super().rotate(0)
        elif(self.coll == "b"):
            if(self.last_dir):
                super().rotate(0)
            else:
                super().rotate(math.pi)
        elif(self.coll == "l"):
            if(self.last_dir):
                super().rotate(math.pi/2)
            else:
                super().rotate(1.5*math.pi)
        elif(self.coll == "r"):
            if(self.last_dir):
                super().rotate(1.5*math.pi)
            else:
                super().rotate(math.pi/2)


  def restart(self, new_ang):
    if(self.last_dir):
        self.last_dir = 0
    else:
        self.last_dir = 1

    self.walling = false
    super().rotate(new_ang)
    self.old_ang = 0


  def done_walling():
      if( self.coll == "t" ):
          if(self.last_dir):
              if(self.x+2*self.radius < self.old_x):
                  return true

           else:
              if(self.x-2*self.radius > self.old_x):
                  return true


       elif( self.coll == "b" ):
          if(self.last_dir):
              if(self.x-2*self.radius > self.old_x):
                  return true

           else:
              if(self.x+2*self.radius < self.old_x):
                  return true


       elif( self.coll == "l" ):
          if(self.last_dir):
              if(self.y-2*self.radius > self.old_y):
                  return true

           else:
              if(self.y+2*self.radius < self.old_y):
                  return true


       else if( self.coll == "r" ):
          if(self.last_dir)
              if(self.y+2*self.radius < self.old_y):
                  return true

           else:
               if(self.y-2*self.radius > self.old_y):
                   return true

      else:
          return false


  def set_reverse(self):
    self.walling = false
    if(self.last_dir):
        self.last_dir = 0
    else:
        self.last_dir = 1

    super().rotate(self.old_ang+math.pi)


  def move(self):
      self.x += (self.speed*math.cos(self.ang))####################
      self.y += (self.speed*math.sin(self.ang))####################

      if(self.x+self.radius>canvas.width): ## unsure of canvas
        self.x=canvas.width-self.radius## unsure of canvas
        if(!self.walling):
            self.store_wall("r")
        else:
            self.restart(random.random()*math.pi + (math.pi/2))

       elif(self.x-self.radius<0):
        self.x=self.radius+.1
        if(!self.walling):
            self.store_wall("l")
        else:
            self.restart(random.random()*math.pi + (1.5*math.pi))

       elif(self.y-self.radius<0):
        self.y=self.radius
        if(!self.walling):
            self.store_wall("t")
        else:
            self.restart(random.random()*math.pi + math.pi)

       elif(self.y+self.radius>canvas.height) ## unsure of canvas
        self.y=canvas.height-self.radius ## unsure of canvas
        if(!self.walling):
            self.store_wall("b")
        else:
            self.restart(random.random()*math.pi)

      if(self.walling && self.done_walling()):
          self.old_x = self.x
          self.old_y = self.y
          self.set_reverse()

      self.trace.append([self.x,self.y])
