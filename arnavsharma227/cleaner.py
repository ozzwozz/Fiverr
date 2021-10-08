class cleaner:
    def __init__(self, x, y, radius, color, ang, speed):
        self.x = x
        self.y = y
        self.startx = x
        self.starty = y
        self.radius = radius
        self.color = color
        self.ang = ang
        self.speed = speed
        self.trace = [[x,y]]
        self.totalAng = 0

  def render(self):
    ctx.globalAlpha=0.1
    ctx.strokeStyle="#000"
    ctx.lineWidth=2*self.radius
    let i =self.trace.length-1
      ctx.beginPath()
      ctx.moveTo(self.trace[i-1][0],self.trace[i-1][1])
      ctx.lineTo(self.trace[i][0],self.trace[i][1])
      ctx.stroke()

    def rotate(self, ang):
        if(math.abs(self.ang - ang) > math.pi)::
            self.totalAng += math.abs(self.ang-ang)-math.pi
        else:
            self.totalAng += math.abs(self.ang-ang)
        self.ang = ang % (math.pi*2)

    def bounceRight(self):
        if(self.ang<math.pi/2):
            self.rotate(math.pi/2 + math.random()*math.pi/2)
        else:
            self.rotate(math.pi + math.random()*math.pi/2)

    def bounceLeft(self):
        if(self.ang>math.pi/2&&self.ang<math.pi):
            self.rotate(math.pi/2 - math.random()*math.pi/2)
        else:
            self.rotate(3*2*math.pi/4 + math.random()*math.pi/2)

    def bounceTop(self):
        if(self.ang<2*math.pi&&self.ang>3*2*math.pi/4)
            self.rotate(math.random()*math.pi/2)
        else:
            self.rotate(math.pi/2+math.random()*math.pi/2)

    def bounceBottom(self):
        if(self.ang<math.pi/2):
            self.rotate(3*2*math.pi/4+math.random()*math.pi/2)
        else:
            self.rotate(math.pi+math.random()*math.pi/2)

    def move(self):
        #self.trace.pop();
        self.x += (self.speed*math.cos(self.ang))
        self.y += (self.speed*math.sin(self.ang))
        if(self.x+self.radius>canvas.width): # unsure of canvas
            self.bounceRight()
            self.x=canvas.width-self.radius
            self.trace.append([self.x,self.y])

        elif(self.x-self.radius<0):
            self.bounceLeft()
            self.x=self.radius+0
            self.trace.append([self.x,self.y])

        elif(self.y-self.radius<0):
            self.bounceTop()
            self.y=self.radius
            self.trace.append([self.x,self.y])

        elif(self.y+self.radius>canvas.height): # unsure of canvas
            self.bounceBottom()
            self.y=canvas.height-self.radius
            self.trace.append([self.x,self.y])

        self.trace.append([self.x,self.y])
