from panda3d.core import loadPrcFileData
loadPrcFileData("", "show-buffers 0")
loadPrcFileData("", "show-frame-rate-meter  1")
loadPrcFileData("", "sync-video 0")
from panda3d.core import *
from direct.showbase import ShowBase
from direct.actor.Actor import Actor
from direct.interval.IntervalGlobal import *
import random

from lightmanager import LightManager


class Demo():
    def __init__(self):       
        base = ShowBase.ShowBase()         
        base.trackball.node().setPos(0, 600, -80)    
        base.trackball.node().setHpr(0, 40, 0) 
        
        LM=LightManager(max_lights=16, ambient=(0.2, 0.2, 0.2))
        print "Number of lights:", LM.max_lights
        
        for i in range(LM.max_lights):
            x=random.randrange(-128, 128)
            y=random.randrange(-128, 128)
            z=random.randrange(1, 50)            
            r=random.uniform(0.0, 1.0)
            g=random.uniform(0.0, 1.0)
            b=random.uniform(0.0, 1.0)            
            LM.addLight(pos=(x, y, z), color=(r,g,b), radius=70.0, specular=1.0)
       
        #preview         
        cm = CardMaker("plane")
        cm.setFrame(-128, 128, -128,128)
        self.plane=render.attachNewNode(cm.generate())
        self.plane.lookAt(0, 0, -1)
        self.plane.flattenStrong()
        #self.plane.hprInterval(30.0, LPoint3(360, 0,0)).loop()
        self.plane.setShader(Shader.load(Shader.SL_GLSL,'v.glsl','f.glsl'))
        self.plane.setShaderInput("normal_map",loader.loadTexture("1324-normal.jpg"))
        self.plane.setTexture(loader.loadTexture("1324.jpg"))
                
        self.smiley = loader.loadModel('smiley')
        self.smiley.reparentTo(render)
        self.smiley.setPos(-5,60,10)
        self.smiley.setScale(10)
        #self.smiley.setH(180)
        axis = render.attachNewNode('axis')
        self.smiley.wrtReparentTo(axis) 
        axis.hprInterval(10.0, LPoint3(-360, 0,0)).loop()
        self.smiley.setShader(Shader.load(Shader.SL_GLSL,'v.glsl','f.glsl'))
        self.smiley.setShaderInput("normal_map",loader.loadTexture("7569-normal.jpg"))

d=Demo()
base.run()        
